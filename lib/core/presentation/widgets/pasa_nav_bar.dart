// ignore_for_file: invalid_use_of_protected_member

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/themes/app_theme.dart';
import 'package:pasa/core/presentation/widgets/hidable.dart';

class PasaNavBar extends HookWidget implements PreferredSizeWidget {
  const PasaNavBar({
    required this.navigationShell,
    this.size,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final Size? size;

  @override
  Size get preferredSize =>
      size ?? const Size.fromHeight(AppTheme.defaultNavBarHeight);

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Hidable(
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: <Widget>[
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: context.l10n.common_home.capitalize(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle_outlined),
                selectedIcon: const Icon(Icons.account_circle),
                label: context.l10n.common_profile.capitalize(),
              ),
            ],
            onDestinationSelected: (int index) => _onItemTapped(context, index),
          ),
        ),
      );

  void _onItemTapped(
    BuildContext context,
    int index,
  ) {
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }
}
