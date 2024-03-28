import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/core/data/repository/user_repository.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'user_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<supabase.SupabaseClient>(),
  MockSpec<supabase.GoTrueClient>(),
])
void main() {
  late UserRepository userRepository;
  late MockSupabaseClient supabaseClient;
  late MockGoTrueClient supabaseAuth;
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
    userRepository = UserRepository(supabaseClient);
    when(supabaseClient.auth).thenReturn(supabaseAuth);
  });

  tearDown(() {
    reset(supabaseClient);
    reset(supabaseAuth);
  });

  group('User', () {
    test(
      'should return some valid user',
      () async {
        when(supabaseAuth.currentSession).thenReturn(
          supabase.Session(
            accessToken: 'accessToken',
            tokenType: 'tokenType',
            user: user,
          ),
        );
        final Either<Failure, User> userRepo = await userRepository.user;
        expect(userRepo.isRight(), true);
      },
    );

    test(
      'should return Failure when session is null',
      () async {
        when(supabaseAuth.currentSession).thenReturn(null);
        final Either<Failure, User> userRepo = await userRepository.user;
        expect(userRepo.isLeft(), true);
      },
    );

    test(
      'should return Failure when an server error is encountered',
      () async {
        when(supabaseClient.auth).thenThrow(
          const supabase.AuthException('message', statusCode: '400'),
        );
        final Either<Failure, User> userRepo = await userRepository.user;
        expect(userRepo.isLeft(), true);
      },
    );

    test(
      'should return Failure when an unexpected error occurs',
      () async {
        when(supabaseClient.auth).thenThrow(throwsException);
        final Either<Failure, User> userRepo = await userRepository.user;

        expect(userRepo.isLeft(), true);
      },
    );
  });
}
