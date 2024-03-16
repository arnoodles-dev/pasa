import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mobile_service_core/features/analytics/i_analytics_repository.dart';
import 'package:pasa/app/helpers/injection.dart';

@injectable
final class GoRouteObserver extends NavigatorObserver {
  GoRouteObserver(
    @factoryParam this._navigatorLocation,
    this._analyticsRepository,
  );

  final String _navigatorLocation;
  final IAnalyticsRepository _analyticsRepository;

  final Logger _logger = getIt<Logger>();

  @override
  Future<void> didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) async {
    final String currentView = (route.settings.name?.isNotEmpty ?? false)
        ? route.settings.name!
        : 'main';
    await _analyticsRepository
        .setCurrentView('$_navigatorLocation:$currentView');
    if (kDebugMode) {
      _logger.t(
        '$_navigatorLocation:$currentView pushed from ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      _logger.t(
        '$_navigatorLocation:${route.settings.name} popped from ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      _logger.t(
        '$_navigatorLocation:${route.settings.name} removed ${previousRoute?.settings.name}',
      );
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      _logger.t(
        '${newRoute?.settings.name} replaced ${oldRoute?.settings.name}',
      );
    }
  }
}
