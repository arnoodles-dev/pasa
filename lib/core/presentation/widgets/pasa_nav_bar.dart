// ignore_for_file: invalid_use_of_protected_member

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/routes/route_name.dart';
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
  Widget build(BuildContext context) {
    final ValueNotifier<int> selectedIndex = useState<int>(0);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Hidable(
        child: NavigationBar(
          selectedIndex: selectedIndex.value,
          destinations: <Widget>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: context.i18n.common_home.capitalize(),
            ),
            const NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description),
              label: 'Activity',
            ),
            const NavigationDestination(
              icon: Icon(
                Icons.add_circle_outline,
                size: 28,
              ),
              label: 'Post',
            ),
            const NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: 'Messages',
            ),
            const NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          onDestinationSelected: (int index) =>
              _onItemTapped(context, index, selectedIndex),
        ),
      ),
    );
  }

  void _onItemTapped(
    BuildContext context,
    int index,
    ValueNotifier<int> selectedIndex,
  ) {
    if (index == 2) {
      context.pushNamed(RouteName.createPost.name);
    } else if (index != selectedIndex.value) {
      selectedIndex.value = index;
      navigationShell.goBranch(index > 2 ? index - 1 : index);
    }
  }
}
