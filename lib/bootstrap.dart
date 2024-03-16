import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:mobile_service/mobile_service_repository.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:mobile_service_core/mobile_service_core.dart';
import 'package:pasa/app/config/app_config.dart';
import 'package:pasa/app/config/chopper_config.dart';
import 'package:pasa/app/config/url_strategy_native.dart'
    if (dart.library.html) 'package:pasa/app/config/url_strategy_web.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/app/observers/app_bloc_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder, Env env) async {
  urlConfig();
  initializeSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeEnvironmentConfig(env);
  await configureDependencies(env);
  await _initializeBackendServices();
  // TODO: add svg paths to preload them on initialization
  await _preloadSVG(<String>[]);

  if (kDebugMode) {
    Bloc.observer = getIt<AppBlocObserver>();
  }

  _handleErrors();

  runApp(await builder());
}

void _handleErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    getIt<ICrashlyticsRepository>().recordFlutterFatalError(details);
    getIt<Logger>().f(
      details.exceptionAsString(),
      error: details,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    getIt<ICrashlyticsRepository>().reportCrash(error, stackTrace);
    return true;
  };
}

Future<void> _initializeBackendServices() async {
  await getIt<IMobileServiceRepository>().initializeServices(
    enablePerformanceMonitor: AppConfig.enablePerformanceMonitor,
  );
  await getIt<IAnalyticsRepository>()
      .setAnalyticsCollectionEnabled(enabled: AppConfig.enableAnalytics);
  await getIt<ICrashlyticsRepository>()
      .setCrashlyticsCollectionEnabled(enabled: AppConfig.enableCrashlytics);
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );
}

void initializeSingletons() {
  getIt
    ..registerLazySingleton<Logger>(
      () => Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(),
        output: ConsoleOutput(),
      ),
    )
    ..registerLazySingleton<ChopperClient>(
      () => ChopperConfig().client,
    )
    ..registerLazySingleton<IMobileServiceRepository>(
      MobileServiceRepository.new,
    );
}

Future<void> initializeEnvironmentConfig(Env env) async {
  switch (env) {
    case Env.development:
    case Env.test:
      await dotenv.load(fileName: Assets.env.envDevelopment);
    case Env.staging:
      await dotenv.load(fileName: Assets.env.envStaging);
    case Env.production:
      await dotenv.load(fileName: Assets.env.envProduction);
  }
}

Future<void> _preloadSVG(List<String> assetPaths) async {
  for (final String path in assetPaths) {
    final SvgAssetLoader loader = SvgAssetLoader(path);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}
