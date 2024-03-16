import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';

import 'app_core_bloc_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IAnalyticsRepository>(),
])
void main() {
  late AppCoreBloc appCoreBloc;
  late MockIAnalyticsRepository analyticsRepository;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    analyticsRepository = MockIAnalyticsRepository();
    appCoreBloc = AppCoreBloc(analyticsRepository);
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
