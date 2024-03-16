import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/constants/route_name.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/app/observers/go_route_observer.dart';
import 'package:pasa/app/utils/transition_page_utils.dart';
import 'package:pasa/core/domain/bloc/remote_config/remote_config_bloc.dart';
import 'package:pasa/core/presentation/views/app_update_screen.dart';
import 'package:pasa/core/presentation/views/main_screen.dart';
import 'package:pasa/core/presentation/views/maintenance_screen.dart';
import 'package:pasa/core/presentation/views/splash_screen.dart';
import 'package:pasa/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:pasa/features/auth/presentation/views/login_screen.dart';
import 'package:pasa/features/home/domain/entity/post.dart';
import 'package:pasa/features/home/presentation/views/home_screen.dart';
import 'package:pasa/features/home/presentation/views/post_details_webview.dart';
import 'package:pasa/features/profile/presentation/views/profile_screen.dart';

part 'app_routes.dart';

@injectable
final class AppRouter {
  AppRouter(
    this._authBloc,
    this._remoteConfigBloc,
  );

  static const String debugLabel = 'root';
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: debugLabel);

  final AuthBloc _authBloc;
  final RemoteConfigBloc _remoteConfigBloc;

  late final GoRouter router = GoRouter(
    routes: _getRoutes(rootNavigatorKey),
    redirect: _routeGuard,
    refreshListenable:
        GoRouterRefreshStream(_authBloc.stream, _remoteConfigBloc.stream),
    initialLocation: RouteName.initial.path,
    observers: <NavigatorObserver>[
      getIt<GoRouteObserver>(param1: debugLabel),
    ],
    navigatorKey: rootNavigatorKey,
  );

  String? _routeGuard(_, GoRouterState goRouterState) {
    final String loginPath = RouteName.login.path;
    final String initialPath = RouteName.initial.path;
    final String homePath = RouteName.home.path;
    final String maintenancePath = RouteName.maintenance.path;
    final String updatePath = RouteName.update.path;
    final bool isMaintenance = _remoteConfigBloc.isMaintenance;
    final bool isForceUpdate = _remoteConfigBloc.isForceUpdate;

    if (isMaintenance) {
      return maintenancePath;
    }
    if (isForceUpdate) {
      return updatePath;
    }

    if ((goRouterState.matchedLocation == maintenancePath ||
            goRouterState.matchedLocation == updatePath) &&
        (!isMaintenance || !isForceUpdate)) {
      return initialPath;
    }

    return _authBloc.state.whenOrNull(
      initial: () => initialPath,
      unauthenticated: () => loginPath,
      authenticated: (_) {
        // Check if the app is in the login screen
        final bool isLoginScreen = goRouterState.matchedLocation == loginPath;
        final bool isSplashScreen =
            goRouterState.matchedLocation == initialPath;

        // Go to home screen if the app is authenticated but tries to go to login
        // screen or is still in the splash screen.
        return isLoginScreen || isSplashScreen ? homePath : null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(
    Stream<dynamic> authStream,
    Stream<dynamic> remoteConfigStream,
  ) {
    notifyListeners();
    _authSubscription = authStream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
    _remoteConfigSubscription =
        remoteConfigStream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _authSubscription;
  late final StreamSubscription<dynamic> _remoteConfigSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
    _remoteConfigSubscription.cancel();
    super.dispose();
  }
}
