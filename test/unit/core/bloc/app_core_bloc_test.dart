import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:pasa/core/domain/interface/i_local_storage_repository.dart';

import 'app_core_bloc_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IAnalyticsRepository>(),
  MockSpec<ILocalStorageRepository>(),
])
void main() {
  late AppCoreBloc appCoreBloc;
  late MockIAnalyticsRepository analyticsRepository;
  late MockILocalStorageRepository localStorageRepository;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    analyticsRepository = MockIAnalyticsRepository();
    localStorageRepository = MockILocalStorageRepository();
    appCoreBloc = AppCoreBloc(analyticsRepository, localStorageRepository);
    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home:
          ScrollController(debugLabel: AppScrollController.home.name),
      AppScrollController.profile:
          ScrollController(debugLabel: AppScrollController.profile.name),
    };
  });

  tearDown(() {
    scrollControllers = <AppScrollController, ScrollController>{};
    reset(analyticsRepository);
    reset(localStorageRepository);
    appCoreBloc.close();
  });

  group('AppCore setScrollControllers', () {
    blocTest<AppCoreBloc, AppCoreState>(
      'should set scrollControllers',
      build: () => appCoreBloc,
      act: (AppCoreBloc bloc) async =>
          bloc.setScrollControllers(scrollControllers),
      expect: () => <AppCoreState>[
        appCoreBloc.state.copyWith(scrollControllers: scrollControllers),
      ],
    );
  });
}
