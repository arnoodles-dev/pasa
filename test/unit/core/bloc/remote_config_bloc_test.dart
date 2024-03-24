import 'dart:async';
import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/core/data/dto/remote_app_config.dart';
import 'package:pasa/core/domain/bloc/remote_config/remote_config_bloc.dart';
import 'package:pasa/core/domain/interface/i_device_repository.dart';

import 'remote_config_bloc_test.mocks.dart';

// ignore_for_file: always_specify_types, strict_raw_type
@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IRemoteConfigRepository>(),
  MockSpec<IDeviceRepository>(),
  MockSpec<StreamSubscription>(),
])
void main() {
  late MockIRemoteConfigRepository remoteConfigRepository;
  late MockIDeviceRepository deviceRepository;
  late RemoteConfigBloc remoteConfigBloc;
  late MockStreamSubscription<dynamic> mockStreamSubscription;
  late Map<String, String> mockConfig;
  late String localLocalization;

  setUp(() async {
    remoteConfigRepository = MockIRemoteConfigRepository();
    deviceRepository = MockIDeviceRepository();
    mockConfig = <String, String>{
      'is_maintenance': 'true',
      'min_supported_version': '1.0.1',
      'android_store_link': 'https://play.google.com/',
      'ios_store_link': 'https://www.apple.com/app-store/',
    };
    mockStreamSubscription = MockStreamSubscription<dynamic>();
    localLocalization = await rootBundle.loadString(Assets.i18n.enUS);
    remoteConfigBloc =
        RemoteConfigBloc(remoteConfigRepository, deviceRepository);
  });

  tearDown(() {
    reset(remoteConfigRepository);
    reset(deviceRepository);
    mockStreamSubscription.cancel();
    remoteConfigBloc.close();
  });

  group('initialize', () {
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should emit the remote config map',
      build: () {
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenAnswer((_) => Future<Map<String, String>>.value(mockConfig));
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc;
      },
      act: (RemoteConfigBloc bloc) async => bloc.initialize(),
      expect: () => <dynamic>[mockConfig],
    );
  });

  group('fetchRemoteConfig', () {
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should emit the remote config map',
      build: () {
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenAnswer((_) => Future<Map<String, String>>.value(mockConfig));
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc..initialize();
      },
      act: (RemoteConfigBloc bloc) async => bloc.fetchRemoteConfig(),
      expect: () => <dynamic>[mockConfig],
    );
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should emit the fallback config map when unexpected error occurs',
      build: () {
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenThrow(throwsException);
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc..initialize();
      },
      act: (RemoteConfigBloc bloc) async => bloc.fetchRemoteConfig(),
      verify: (RemoteConfigBloc bloc) => expect(
        bloc.state,
        RemoteAppConfig.fallback()
            .copyWith(en: jsonDecode(localLocalization) as Map<String, dynamic>)
            .toJson(),
      ),
    );
  });

  group('getters', () {
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should get isMaintenance & isForceUpdate',
      build: () {
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenAnswer((_) => Future<Map<String, String>>.value(mockConfig));
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc;
      },
      act: (RemoteConfigBloc bloc) async => bloc.initialize(),
      verify: (RemoteConfigBloc bloc) {
        expect(bloc.isMaintenance, true);
        expect(bloc.isForceUpdate, true);
      },
    );
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should get android store link',
      build: () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenAnswer((_) => Future<Map<String, String>>.value(mockConfig));
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc;
      },
      act: (RemoteConfigBloc bloc) async => bloc.initialize(),
      verify: (RemoteConfigBloc bloc) {
        expect(bloc.storeLink, 'https://play.google.com/');
      },
    );
    blocTest<RemoteConfigBloc, Map<String, dynamic>>(
      'should get ios store link',
      build: () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        when(remoteConfigRepository.fetchRemoteConfig())
            .thenAnswer((_) => Future<Map<String, String>>.value(mockConfig));
        when(remoteConfigRepository.initializeRemoteConfig(any))
            .thenAnswer((_) => Future.value(mockStreamSubscription));
        return remoteConfigBloc;
      },
      act: (RemoteConfigBloc bloc) async => bloc.initialize(),
      verify: (RemoteConfigBloc bloc) {
        expect(bloc.storeLink, 'https://www.apple.com/app-store/');
      },
    );
  });
}
