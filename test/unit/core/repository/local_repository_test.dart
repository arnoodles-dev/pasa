import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/core/data/repository/local_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<SharedPreferences>(),
  MockSpec<FlutterSecureStorage>(),
])
void main() {
  late MockSharedPreferences unsecuredStorage;
  late MockFlutterSecureStorage secureStorage;
  late LocalStorageRepository localStorageRepository;

  setUp(() {
    unsecuredStorage = MockSharedPreferences();
    secureStorage = MockFlutterSecureStorage();
    localStorageRepository =
        LocalStorageRepository(secureStorage, unsecuredStorage);
  });

  tearDown(() {
    unsecuredStorage.clear();
    secureStorage.deleteAll();
    reset(unsecuredStorage);
    reset(secureStorage);
  });

  group('Secure Storage', () {
    group('access token', () {
      test(
        'should return the access token',
        () async {
          const String matcher = 'accessToken';
          when(secureStorage.read(key: 'access_token'))
              .thenAnswer((_) async => matcher);

          final String? accessToken =
              await localStorageRepository.getAccessToken();

          expect(accessToken, matcher);
        },
      );
      test(
        'should be called once if the access token is saved successfully',
        () async {
          when(
            secureStorage.write(
              key: 'access_token',
              value: anyNamed('value'),
            ),
          ).thenAnswer((_) async => true);

          await localStorageRepository.setAccessToken('access_token');

          verify(localStorageRepository.setAccessToken('access_token'))
              .called(1);
        },
      );
      test(
        'should throw an exception if an unexpected error occurs when saving',
        () async {
          when(
            secureStorage.write(
              key: 'access_token',
              value: anyNamed('value'),
            ),
          ).thenThrow(throwsException);

          expect(
            () => localStorageRepository.setAccessToken('access_token'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('id token', () {
      test(
        'should return the id token',
        () async {
          const String matcher = 'idToken';
          when(secureStorage.read(key: 'id_token'))
              .thenAnswer((_) async => matcher);

          final String? idToken = await localStorageRepository.getIdToken();

          expect(idToken, matcher);
        },
      );
      test(
        'should be called once if the id token is saved',
        () async {
          when(
            secureStorage.write(
              key: 'id_token',
              value: anyNamed('value'),
            ),
          ).thenAnswer((_) async => true);

          await localStorageRepository.setIdToken('id_token');

          verify(localStorageRepository.setIdToken('id_token')).called(1);
        },
      );
      test(
        'should throw an exception if an unexpected error occurs when saving',
        () async {
          when(
            secureStorage.write(
              key: 'id_token',
              value: anyNamed('value'),
            ),
          ).thenThrow(throwsException);

          expect(
            () => localStorageRepository.setIdToken('id_token'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });

  group('Unsecure Storage', () {
    group('is onboarding done', () {
      test(
        'should return the is_onboarding_done flag',
        () async {
          when(unsecuredStorage.getBool('is_onboarding_done')).thenReturn(true);

          final bool? isOnboardingDone =
              await localStorageRepository.getIsOnboardingDone();

          expect(isOnboardingDone, true);
        },
      );
      test(
        'should be called once if is_onboarding_done flag is saved',
        () async {
          when(
            unsecuredStorage.setBool('is_onboarding_done', any),
          ).thenAnswer((_) async => true);

          await localStorageRepository.setIsOnboardingDone();

          verify(localStorageRepository.setIsOnboardingDone()).called(1);
        },
      );

      test(
        'should return false if an unexpected error occurs when saving',
        () async {
          when(unsecuredStorage.setBool('is_onboarding_done', any))
              .thenThrow(throwsException);

          expect(
            () => localStorageRepository.setIsOnboardingDone(),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
