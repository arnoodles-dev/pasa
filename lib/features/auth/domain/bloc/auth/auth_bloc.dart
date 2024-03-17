import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:pasa/app/helpers/extensions/cubit_ext.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:pasa/core/domain/interface/i_user_repository.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(
    this._userRepository,
    this._authRepository,
    this._analyticsRepository,
    this._crashlyticsRepository,
  ) : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final IAnalyticsRepository _analyticsRepository;
  final ICrashlyticsRepository _crashlyticsRepository;

  Future<void> initialize({bool isOnboardingDone = true}) async {
    try {
      safeEmit(const AuthState.initial());
      isOnboardingDone
          ? _emitAuthState(await _userRepository.user, isLogout: true)
          : safeEmit(const AuthState.unauthenticated());
    } catch (error) {
      _emitError(error);
    }
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
        //TODO: change 'email' to login method used
        _analyticsRepository.logLogin('email');
        //TODO: change 'userId' to the actual user id when auth is implemented
        _crashlyticsRepository.setUserId('userId');
        safeEmit(
          AuthState.authenticated(
            user: user,
          ),
        );
      },
    );
  }

  void _emitError(Object error) {
    log(error.toString());
    safeEmit(
      AuthState.failed(
        Failure.unexpected(error.toString()),
      ),
    );
  }
}
