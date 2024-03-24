import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:pasa/core/domain/interface/i_user_repository.dart';
import 'package:pasa/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:pasa/features/auth/domain/interface/i_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../utils/test_utils.dart';
import 'auth_bloc_test.mocks.dart';

// ignore_for_file: always_specify_types, strict_raw_type
@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IUserRepository>(),
  MockSpec<AuthBloc>(),
  MockSpec<IAuthRepository>(),
  MockSpec<IAnalyticsRepository>(),
  MockSpec<ICrashlyticsRepository>(),
  MockSpec<StreamSubscription>(),
])
void main() {
  late MockIUserRepository userRepository;
  late MockIAuthRepository authRepository;
  late MockIAnalyticsRepository analyticsRepository;
  late MockICrashlyticsRepository crashlyticsRepository;
  late MockStreamSubscription<supabase.AuthState> mockStreamSubscription;
  late AuthBloc authBloc;

  setUp(() {
    userRepository = MockIUserRepository();
    authRepository = MockIAuthRepository();
    analyticsRepository = MockIAnalyticsRepository();
    crashlyticsRepository = MockICrashlyticsRepository();
    authBloc = AuthBloc(
      userRepository,
      authRepository,
      crashlyticsRepository,
    );
    mockStreamSubscription = MockStreamSubscription<supabase.AuthState>();
    when(authRepository.onAuthStateChange(any))
        .thenAnswer((_) => mockStreamSubscription);
  });

  tearDown(() {
    authBloc.close();
    mockStreamSubscription.cancel();
    reset(analyticsRepository);
    reset(userRepository);
    reset(authRepository);
  });

  group('AuthBloc initialize', () {
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated when onboarding is not done',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user)
            .thenAnswer((_) async => Either<Failure, User>.right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(isOnboardingDone: false),
      expect: () => <AuthState>[
        const AuthState.initial(),
        const AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(Either<Failure, User>.left(const Failure.userNotFound()));
        when(userRepository.user).thenAnswer(
          (_) async => Either<Failure, User>.left(const Failure.userNotFound()),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => const <AuthState>[
        AuthState.initial(),
        AuthState.failed(Failure.userNotFound()),
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user)
            .thenAnswer((_) async => Either<Failure, User>.right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[
        const AuthState.initial(),
        AuthState.authenticated(user: mockUser),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.initialize(),
      expect: () => <AuthState>[
        const AuthState.initial(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc getUser ', () {
    setUp(() async {
      authBloc = AuthBloc(
        userRepository,
        authRepository,
        crashlyticsRepository,
      );
      provideDummy(Either<Failure, User>.right(mockUser));
      when(userRepository.user)
          .thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(
          Either<Failure, User>.left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );
        when(userRepository.user).thenAnswer(
          (_) async => Either<Failure, User>.left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => const <AuthState>[
        AuthState.loading(),
        AuthState.failed(
          Failure.serverError(StatusCode.http401, 'unauthorized'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated with user state',
      build: () {
        provideDummy(Either<Failure, User>.right(mockUser));
        when(userRepository.user)
            .thenAnswer((_) async => Either<Failure, User>.right(mockUser));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.authenticated(
          user: mockUser,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit  a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.getUser(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('AuthBloc logout ', () {
    setUp(() async {
      authBloc = AuthBloc(
        userRepository,
        authRepository,
        crashlyticsRepository,
      );
      provideDummy(Either<Failure, User>.right(mockUser));
      when(userRepository.user)
          .thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(Either<Failure, Unit>.right(unit));
        when(authRepository.logout())
            .thenAnswer((_) async => Either<Failure, Unit>.right(unit));

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => const <AuthState>[
        AuthState.loading(),
        AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        provideDummy(
          Either<Failure, Unit>.left(
            Failure.unexpected(throwsException.toString()),
          ),
        );
        when(authRepository.logout()).thenAnswer(
          (_) async => Either<Failure, Unit>.left(
            Failure.unexpected(throwsException.toString()),
          ),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state when unexpected error occurs',
      build: () {
        when(authRepository.logout()).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.logout(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(
          Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });

  group('AuthBloc authenticate', () {
    setUp(() async {
      authBloc = AuthBloc(
        userRepository,
        authRepository,
        crashlyticsRepository,
      );
      provideDummy(
        Either<Failure, User>.right(mockUser),
      );
      when(userRepository.user)
          .thenAnswer((_) async => Either<Failure, User>.right(mockUser));
      await authBloc.initialize();
    });
    blocTest<AuthBloc, AuthState>(
      'should emit an authenticated user state',
      build: () => authBloc,
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.authenticated(
          user: mockUser,
        ),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit an unauthenticated with null user state',
      build: () {
        provideDummy(
          Either<Failure, User>.left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );
        when(userRepository.user).thenAnswer(
          (_) async => Either<Failure, User>.left(
            const Failure.serverError(StatusCode.http401, 'unauthorized'),
          ),
        );

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        const AuthState.failed(
          Failure.serverError(StatusCode.http401, 'unauthorized'),
        ),
        const AuthState.unauthenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return authBloc;
      },
      act: (AuthBloc bloc) => bloc.authenticate(),
      expect: () => <AuthState>[
        const AuthState.loading(),
        AuthState.failed(Failure.unexpected(throwsException.toString())),
      ],
    );
  });
}
