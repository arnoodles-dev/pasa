import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/features/auth/domain/bloc/login/login_bloc.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_bloc_test.mocks.dart';

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<IAuthRepository>(),
    MockSpec<IAnalyticsRepository>(),
  ],
)
void main() {
  late MockIAuthRepository authRepository;
  late MockIAnalyticsRepository analyticsRepository;
  late LoginBloc loginBloc;

  late Failure failure;

  setUp(() {
    authRepository = MockIAuthRepository();
    analyticsRepository = MockIAnalyticsRepository();
  });

  tearDown(() {
    reset(analyticsRepository);
    reset(authRepository);
  });

  group('LoginBloc loginWithProvider', () {
    setUp(() {
      loginBloc = LoginBloc(authRepository, analyticsRepository);
      failure = const Failure.serverError(
        StatusCode.http500,
        'INTERNAL SERVER ERROR',
      );
    });
    blocTest<LoginBloc, LoginState>(
      'should emit an the a success state',
      build: () {
        provideDummy(
          Either<Failure, AuthResponse>.right(AuthResponse()),
        );
        when(authRepository.loginWithProvider(any)).thenAnswer(
          (_) async => Either<Failure, AuthResponse>.right(AuthResponse()),
        );

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.loginWithProvider(OAuthProvider.google),
      expect: () => <dynamic>[
        LoginState.initial(),
        const LoginState(
          isLoading: false,
          loginStatus: LoginStatus.success(),
        ),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a failed state',
      build: () {
        provideDummy(
          Either<Failure, AuthResponse>.left(failure),
        );
        when(authRepository.loginWithProvider(any)).thenAnswer(
          (_) async => Either<Failure, AuthResponse>.left(failure),
        );

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.loginWithProvider(OAuthProvider.google),
      expect: () => <dynamic>[
        LoginState.initial(),
        LoginState(
          isLoading: false,
          loginStatus: LoginStatus.failed(failure),
        ),
        LoginState.initial().copyWith(isLoading: false),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'should emit a unexpected error state',
      build: () {
        provideDummy(
          Either<Failure, AuthResponse>.left(
            Failure.unexpected(throwsException.toString()),
          ),
        );
        when(authRepository.loginWithProvider(any)).thenThrow(throwsException);

        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.loginWithProvider(OAuthProvider.google),
      expect: () => <dynamic>[
        LoginState.initial(),
        LoginState(
          isLoading: false,
          loginStatus: LoginStatus.failed(
            Failure.unexpected(throwsException.toString()),
          ),
        ),
        LoginState.initial().copyWith(isLoading: false),
      ],
    );
  });
}
