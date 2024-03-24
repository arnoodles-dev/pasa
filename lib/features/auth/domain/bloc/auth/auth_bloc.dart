import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:pasa/app/helpers/extensions/cubit_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/core/data/dto/user.dto.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:pasa/core/domain/interface/i_user_repository.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(
    this._userRepository,
    this._authRepository,
    this._crashlyticsRepository,
  ) : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final ICrashlyticsRepository _crashlyticsRepository;
  final Logger logger = getIt<Logger>();
  late StreamSubscription<supabase.AuthState> _authStateSubscription;

  Future<void> initialize({bool isOnboardingDone = true}) async {
    try {
      safeEmit(const AuthState.initial());
      _onAuthStateChanged();
      isOnboardingDone
          ? _emitAuthState(await _userRepository.user, isLogout: true)
          : safeEmit(const AuthState.unauthenticated());
    } catch (error) {
      _emitError(error);
    }
  }

  void _onAuthStateChanged() {
    _authStateSubscription =
        _authRepository.onAuthStateChange((supabase.AuthState authState) {
      safeEmit(
        authState.session != null
            ? AuthState.authenticated(
                user: UserDTO.fromSupabase(authState.session!.user).toDomain(),
              )
            : const AuthState.unauthenticated(),
      );
    });
  }

  Future<void> getUser() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user);
    } catch (error) {
      _emitError(error);
    }
  }

  Future<void> authenticate() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user, isLogout: true);
    } catch (error) {
      _emitError(error);
    }
  }

  Future<void> logout() async {
    try {
      safeEmit(const AuthState.loading());
      final Either<Failure, Unit> possibleFailure =
          await _authRepository.logout();
      safeEmit(
        possibleFailure.fold(
          AuthState.failed,
          (_) => const AuthState.unauthenticated(),
        ),
      );
    } catch (error) {
      _emitError(error);
    }
  }

  /// if isLogout = true then logout app on Failure else retain current screen
  void _emitAuthState(
    Either<Failure, User> possibleFailure, {
    bool isLogout = false,
  }) {
    possibleFailure.fold(
      (Failure failure) {
        safeEmit(AuthState.failed(failure));
        if (isLogout) {
          safeEmit(const AuthState.unauthenticated());
        }
      },
      (User user) {
        _crashlyticsRepository.setUserId(user.uid.getOrCrash());
        safeEmit(
          AuthState.authenticated(
            user: user,
          ),
        );
      },
    );
  }

  void _emitError(Object error) {
    logger.e(error.toString());
    safeEmit(
      AuthState.failed(
        Failure.unexpected(error.toString()),
      ),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
