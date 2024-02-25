import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/utils/dialog_utils.dart';
import 'package:pasa/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:pasa/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:pasa/core/presentation/widgets/connectivity_checker.dart';
import 'package:pasa/core/presentation/widgets/pasa_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _initScrollControllers() {
    final Map<AppScrollController, ScrollController> controllers =
        <AppScrollController, ScrollController>{};
    for (final AppScrollController appScrollController
        in AppScrollController.values) {
      final ScrollController scrollController =
          ScrollController(debugLabel: appScrollController.name);
      scrollController.addListener(
        () => _addListener(scrollController, context.read<HidableBloc>()),
      );
      controllers.putIfAbsent(appScrollController, () => scrollController);
    }
    context.read<AppCoreBloc>().setScrollControllers(controllers);
  }

  void _addListener(
    ScrollController scrollController,
    HidableBloc hidableBloc,
  ) {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      hidableBloc.setVisibility(isVisible: true);
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      hidableBloc.setVisibility(isVisible: false);
    }
  }

  void _onPopInvoked(bool didPop) {
    if (!didPop) {
      if (widget.navigationShell.currentIndex != 0) {
        widget.navigationShell.goBranch(0);
      } else {
        DialogUtils.showExitDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initScrollControllers();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: _onPopInvoked,
        child: ConnectivityChecker.scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: PasaNavBar(
            navigationShell: widget.navigationShell,
          ),
          backgroundColor: context.colorScheme.background,
        ),
      );
}
