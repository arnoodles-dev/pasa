import 'package:flutter/widgets.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';

enum MobileServiceType {
  gms,
  hms,
}

abstract class IMobileServiceRepository {
  // Services

  late IAnalyticsRepository _analyticsRepository;
  late IRemoteConfigRepository _remoteConfigRepository;
  late ICrashlyticsRepository _crashlyticsRepository;

  IAnalyticsRepository get analyticsRepository => _analyticsRepository;
  IRemoteConfigRepository get remoteConfigRepository => _remoteConfigRepository;
  ICrashlyticsRepository get crashlyticsRepository => _crashlyticsRepository;

  Future<void> initializeServices({
    required bool enablePerformanceMonitor,
  }) async {
    await init(enablePerformanceMonitor: enablePerformanceMonitor);

    _analyticsRepository = provideAnalyticsRepository();
    _remoteConfigRepository = provideRemoteConfigRepository();
    _crashlyticsRepository = provideCrashlyticsRepository();
  }

  Future<void> init({required bool enablePerformanceMonitor});

  @protected
  IAnalyticsRepository provideAnalyticsRepository();

  @protected
  ICrashlyticsRepository provideCrashlyticsRepository();

  @protected
  IRemoteConfigRepository provideRemoteConfigRepository();

  MobileServiceType provideMobileServiceType();
}
