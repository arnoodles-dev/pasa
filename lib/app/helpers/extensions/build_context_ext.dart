import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/app/helpers/app_localization.dart';

extension BuildContextExt on BuildContext {
  AppLocalization get i18n => AppLocalization.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  GoRouter get goRouter => GoRouter.of(this);
}
