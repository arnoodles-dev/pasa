import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';

class GMSAnalyticsRepository extends IAnalyticsRepository {
  GMSAnalyticsRepository() : _firebaseAnalytics = FirebaseAnalytics.instance {
    _navObserver = FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
  }

  final FirebaseAnalytics _firebaseAnalytics;
  late FirebaseAnalyticsObserver _navObserver;

  late String? _currentUserId;

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) =>
      _firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);

  @override
  Future<void> logEvent({
    required String screen,
    required String eventLabel,
    required String eventCategory,
    required bool isLoggedIn,
    String? eventAction,
    String? eventName,
    bool useEventLabel = false,
    Map<String, dynamic>? payload,
  }) async {
    log('LOGGING ANALYTICS EVENT Screen[$screen], Title[$eventLabel], Arguments$payload');

    final Map<String, dynamic> base = <String, dynamic>{
      'event_category': eventCategory,
      'event_label': eventLabel,
      'event_action': eventAction ?? eventLabel,
      'encrypted_msisdn': _currentUserId,
      'loggedin_status': isLoggedIn ||
              (_currentUserId != null || (_currentUserId?.isNotEmpty ?? true))
          ? 'Yes'
          : 'No',
    };

    payload = payload ?? <String, dynamic>{}
      ..addAll(base);

    log('Analytics final payload $payload');

    await _firebaseAnalytics.logScreenView(screenName: screen);
    await _firebaseAnalytics.logEvent(
      name: eventName ?? eventLabel,
      parameters: payload,
    );
  }

  @override
  NavigatorObserver get navigatorObserver => _navObserver;

  @override
  Future<void> logLogin(String loginMethod) async {
    await _firebaseAnalytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logOnOpenApp() => _firebaseAnalytics.logAppOpen();

  @override
  Future<void> setCurrentView(String view) async =>
      _firebaseAnalytics.logScreenView(screenName: view);

  @override
  Future<void> setUserProperties({
    required String userId,
    String? userRole,
  }) async {
    final List<int> encoded = utf8.encode(userId);
    _currentUserId = sha1.convert(encoded).toString();
    log('HASHED FIREBASE USER ID $_currentUserId');
    await _firebaseAnalytics.setUserId(id: _currentUserId);
  }
}
