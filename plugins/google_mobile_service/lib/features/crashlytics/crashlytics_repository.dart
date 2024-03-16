import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_service_core/features/crashlytics/i_crashlytics_repository.dart';

class GMSCrashlyticsRepository extends ICrashlyticsRepository {
  GMSCrashlyticsRepository();

  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  @override
  Future<void> setCrashlyticsCollectionEnabled({required bool enabled}) =>
      _crashlytics.setCrashlyticsCollectionEnabled(enabled);

  @override
  Future<void> reportCrash(
    Object error,
    StackTrace? stackTrace, {
    bool isFatal = false,
  }) async {
    await _crashlytics.recordError(error, stackTrace, fatal: isFatal);
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    await _crashlytics.recordFlutterFatalError(details);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }
}
