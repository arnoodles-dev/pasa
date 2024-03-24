import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:pasa/app/helpers/extensions/cubit_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_bloc.freezed.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> {
  LoginBloc(
    this._authRepository,
    this._analyticsRepository,
  ) : super(LoginState.initial());

  final IAuthRepository _authRepository;
  final IAnalyticsRepository _analyticsRepository;
  final Logger logger = getIt<Logger>();

  Future<void> loginWithProvider(OAuthProvider provider) async {
    try {
      safeEmit(state.copyWith(isLoading: true));

      final Either<Failure, AuthResponse> possibleFailure =
          await _authRepository.loginWithProvider(provider);

      possibleFailure.fold(
        _emitFailure,
        (_) async {
          await _analyticsRepository.logLogin(provider.name);
          safeEmit(
            state.copyWith(
              isLoading: false,
              loginStatus: const LoginStatus.success(),
            ),
          );
        },
      );
    } catch (error) {
      logger.e(error.toString());
      _emitFailure(Failure.unexpected(error.toString()));
    }
  }
  //TODO: implement this when sms provider is available
  // Future<void> loginWithPhoneNumber(String phoneNumber) async {
  //   try {
  //     safeEmit(state.copyWith(isLoading: true));
  //     final PhoneNumber validPhoneNumber = PhoneNumber(phoneNumber);
  //     if (validPhoneNumber.isValid()) {
  //       final Either<Failure, Unit> possibleFailure =
  //           await _authRepository.loginWithPhoneNumber(validPhoneNumber);
  //       possibleFailure.fold(
  //         _emitFailure,
  //         (_) => safeEmit(
  //           state.copyWith(
  //             isLoading: false,
  //             loginStatus: const LoginStatus.success(),
  //           ),
  //         ),
  //       );
  //     } else {
  //       _emitFailure(const Failure.invalidPhoneNumber());
  //     }
  //   } catch (error) {
  //     logger.e(error.toString());
  //     _emitFailure(Failure.unexpected(error.toString()));
  //   }
  // }

  void _emitFailure(Failure failure) {
    safeEmit(
      state.copyWith(
        isLoading: false,
        loginStatus: LoginStatus.failed(failure),
      ),
    );
    // emit the initial state to reset the error
    safeEmit(
      state.copyWith(
        loginStatus: const LoginStatus.initial(),
      ),
    );
  }
}
