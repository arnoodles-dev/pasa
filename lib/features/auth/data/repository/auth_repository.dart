import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/helpers/extensions/int_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/interface/i_local_storage_repository.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  const AuthRepository(
    this._supabase,
    this._localStorageRepository,
    this._googleSignIn,
  );

  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;
  final ILocalStorageRepository _localStorageRepository;

  Logger get logger => getIt<Logger>();

  @override
  StreamSubscription<AuthState> onAuthStateChange(
    void Function(AuthState)? onData,
  ) =>
      _supabase.auth.onAuthStateChange.listen(onData);

  @override
  Future<Either<Failure, AuthResponse>> loginWithProvider(
    OAuthProvider provider,
  ) async {
    try {
      final (String idToken, String accessToken) = switch (provider) {
        OAuthProvider.google => await _signInWithGoogle(),
        _ => ('', '')
      };
      final AuthResponse reponse = await _supabase.auth.signInWithIdToken(
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
      );

      return right(reponse);
    } on AuthException catch (error) {
      return left(_onAuthError(error));
    } catch (error) {
      logger.e(error.toString());
      return left(Failure.unexpected(error.toString()));
    }
  }
  //TODO: implement this when sms provider is available
  // @override
  // Future<Either<Failure, Unit>> loginWithPhoneNumber(
  //   PhoneNumber phone,
  // ) async {
  //   try {
  //     await _supabase.auth.signInWithOtp(phone: phone.getOrCrash());
  //     return right(unit);
  //   } on AuthException catch (error) {
  //     return left(_onAuthError(error));
  //   } catch (error) {
  //     logger.e(error.toString());
  //     return left(Failure.unexpected(error.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await Future.wait(<Future<void>>[
        _saveTokens(null, null),
        _supabase.auth.signOut(),
      ]);
      return right(unit);
    } on AuthException catch (error) {
      return left(_onAuthError(error));
    } catch (error) {
      logger.e(error.toString());
      return left(Failure.unexpected(error.toString()));
    }
  }

  Failure _onAuthError(AuthException error) {
    logger.e(error.toString());
    final int? code = int.tryParse(error.statusCode ?? '');
    final StatusCode statusCode =
        code != null ? code.statusCode : StatusCode.http000;
    return Failure.serverError(statusCode, error.message);
  }

  Future<(String, String)> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw Exception('No Access Token found.');
      }
      if (idToken == null) {
        throw Exception('No ID Token found.');
      }
      // if true then an error occured while saving
      await _saveTokens(accessToken, idToken);

      return (idToken, accessToken);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> _saveTokens(String? accessToken, String? idToken) =>
      Future.wait(<Future<void>>[
        _localStorageRepository.setAccessToken(accessToken),
        _localStorageRepository.setIdToken(idToken),
      ]);
}
