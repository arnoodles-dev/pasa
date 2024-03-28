import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:mobile_service/features/analytics/analytics_repository.dart';
import 'package:mobile_service/features/crashlytics/crashlytics_repository.dart';
import 'package:mobile_service/features/remote_config/remote_config_repository.dart';
import 'package:mobile_service/firebase_options.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';
import 'package:mobile_service_core/features/remote_config/i_remote_config_repository.dart';
import 'package:mobile_service_core/mobile_service_core.dart';

class MobileServiceRepository extends IMobileServiceRepository {
  @override
  Future<void> init({required bool enablePerformanceMonitor}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(enablePerformanceMonitor);
  }

  @override
  IAnalyticsRepository provideAnalyticsRepository() => GMSAnalyticsRepository();

  @override
  MobileServiceType provideMobileServiceType() => MobileServiceType.gms;

  @override
  IRemoteConfigRepository provideRemoteConfigRepository() =>
      GMSRemoteConfigRepository();

  @override
  ICrashlyticsRepository provideCrashlyticsRepository() =>
      GMSCrashlyticsRepository();
}
