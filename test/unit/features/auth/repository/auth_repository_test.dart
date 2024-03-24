import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/core/data/repository/local_storage_repository.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/features/auth/data/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../utils/mock_google_sign_in.dart';
import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<LocalStorageRepository>(),
  MockSpec<supabase.SupabaseClient>(),
  MockSpec<supabase.GoTrueClient>(),
])
void main() {
  late MockSupabaseClient supabaseClient;
  late MockGoTrueClient supabaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockLocalStorageRepository localStorageRepository;
  late AuthRepository authRepository;

  late supabase.AuthResponse authResponse;
  final supabase.User user = supabase.User(
    id: 'id',
    appMetadata: <String, dynamic>{},
    userMetadata: <String, dynamic>{},
    aud: 'aud',
    createdAt: DateTime.now().toIso8601String(),
  );

  setUp(() {
    supabaseClient = MockSupabaseClient();
    supabaseAuth = MockGoTrueClient();
    localStorageRepository = MockLocalStorageRepository();
    googleSignIn = MockGoogleSignIn();
    authRepository =
        AuthRepository(supabaseClient, localStorageRepository, googleSignIn);
    authResponse = supabase.AuthResponse(
      session: supabase.Session(
        accessToken: '',
        tokenType: '',
        user: user,
      ),
      user: user,
    );
    when(localStorageRepository.setAccessToken(any))
        .thenAnswer((_) => Future<bool>.value(true));
    when(localStorageRepository.setIdToken(any))
        .thenAnswer((_) => Future<bool>.value(true));
  });

  tearDown(() {
    supabaseClient.dispose();
    reset(supabaseClient);
    reset(supabaseAuth);
    reset(localStorageRepository);
  });

  group('Login', () {
    test(
      'should return a AuthResponse when login is successful',
      () async {
        when(
          supabaseAuth.signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: 'idToken',
            accessToken: 'accessToken',
          ),
        ).thenAnswer(
          (_) async => authResponse,
        );
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, supabase.AuthResponse> result =
            await authRepository
                .loginWithProvider(supabase.OAuthProvider.google);

        expect(result.isRight(), true);
      },
    );

    test(
      'should return a failure when login encounters a server error',
      () async {
        when(
          supabaseAuth.signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: 'idToken',
            accessToken: 'accessToken',
          ),
        ).thenThrow(const supabase.AuthException('message'));
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, supabase.AuthResponse> result =
            await authRepository
                .loginWithProvider(supabase.OAuthProvider.google);

        expect(result.isLeft(), true);
      },
    );

    test(
      'should return a failure when login encounters an unexpected error',
      () async {
        when(
          supabaseAuth.signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: 'idToken',
            accessToken: 'accessToken',
          ),
        ).thenThrow(throwsException);
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, supabase.AuthResponse> result =
            await authRepository
                .loginWithProvider(supabase.OAuthProvider.google);
        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when saving the access token',
      () async {
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) => Future<bool>.value(false));
        when(
          supabaseAuth.signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: 'idToken',
            accessToken: 'accessToken',
          ),
        ).thenThrow(throwsException);
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, supabase.AuthResponse> result =
            await authRepository
                .loginWithProvider(supabase.OAuthProvider.google);
        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when saving the id token',
      () async {
        when(localStorageRepository.setIdToken(any))
            .thenAnswer((_) => Future<bool>.value(false));
        when(
          supabaseAuth.signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: 'idToken',
            accessToken: 'accessToken',
          ),
        ).thenThrow(throwsException);
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, supabase.AuthResponse> result =
            await authRepository
                .loginWithProvider(supabase.OAuthProvider.google);
        expect(result.isLeft(), true);
      },
    );
  });
  group('Logout', () {
    test(
      'should return a unit when logout is successful',
      () async {
        when(localStorageRepository.setIdToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(
          supabaseAuth.signOut(),
        ).thenAnswer(
          (_) async => Future<void>.value(),
        );
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, Unit> result = await authRepository.logout();
        expect(result.isRight(), true);
      },
    );
    test(
      'should return a failure when logout encounters an authexception error',
      () async {
        when(localStorageRepository.setIdToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(
          supabaseAuth.signOut(),
        ).thenThrow(const supabase.AuthException('message', statusCode: '400'));
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, Unit> result = await authRepository.logout();
        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when logout encounters an unexpected error',
      () async {
        when(localStorageRepository.setIdToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(
          supabaseAuth.signOut(),
        ).thenThrow(throwsException);
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, Unit> result = await authRepository.logout();
        expect(result.isLeft(), true);
      },
    );

    test(
      'should return a failure when an error occurs when clearing id token',
      () async {
        when(localStorageRepository.setIdToken(any)).thenThrow(throwsException);
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(
          supabaseAuth.signOut(),
        ).thenAnswer(
          (_) async => Future<void>.value(),
        );
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, Unit> result = await authRepository.logout();
        expect(result.isLeft(), true);
      },
    );

    test(
      'should return a failure when an error occurs when clearing id token',
      () async {
        when(localStorageRepository.setIdToken(any))
            .thenAnswer((_) => Future<void>.value());
        when(localStorageRepository.setAccessToken(any))
            .thenThrow(throwsException);
        when(
          supabaseAuth.signOut(),
        ).thenAnswer(
          (_) async => Future<void>.value(),
        );
        when(supabaseClient.auth).thenReturn(supabaseAuth);

        final Either<Failure, Unit> result = await authRepository.logout();
        expect(result.isLeft(), true);
      },
    );
  });
}
