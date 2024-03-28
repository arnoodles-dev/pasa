import 'package:flutter/material.dart';

/// Defines the color palette for the Shouts UI.
abstract final class AppColors {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  /// Default colors for shimmer
  static const Color lightShimmerHighlight = Color(0xffE6E8EB);
  static const Color darkShimmerHighlight = Color(0xff2A2C2E);
  static const Color lightShimmerBase = Color(0xffF9F9FB);
  static const Color darkShimmerBase = Color(0xff3A3E3F);

  /// Text url default color
  static const Color defaultTextUrl = Colors.lightBlue;
  static const Color defaultBoxShadow = Color(0x1F000000);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF005BC0),
    onPrimary: white,
    primaryContainer: Color(0xFFD8E2FF),
    onPrimaryContainer: Color(0xFF001A41),
    secondary: Color(0xFF305DA8),
    onSecondary: white,
    secondaryContainer: Color(0xFFD8E2FF),
    onSecondaryContainer: Color(0xFF001A41),
    tertiary: Color(0xFF006C4D),
    onTertiary: white,
    tertiaryContainer: Color(0xFF88F8C8),
    onTertiaryContainer: Color(0xFF002115),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: white,
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFEFBFF),
    onBackground: Color(0xFF1B1B1F),
    surface: Color(0xFFFEFBFF),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE1E2EC),
    onSurfaceVariant: Color(0xFF44474F),
    outline: Color(0xFF74777F),
    onInverseSurface: Color(0xFFF2F0F4),
    inverseSurface: Color(0xFF303033),
    inversePrimary: Color(0xFFADC7FF),
    shadow: black,
    surfaceTint: Color(0xFF005BC0),
    outlineVariant: Color(0xFFC4C6D0),
    scrim: black,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFADC7FF),
    onPrimary: Color(0xFF002E68),
    primaryContainer: Color(0xFF004493),
    onPrimaryContainer: Color(0xFFD8E2FF),
    secondary: Color(0xFFADC7FF),
    onSecondary: Color(0xFF002E68),
    secondaryContainer: Color(0xFF0C448E),
    onSecondaryContainer: Color(0xFFD8E2FF),
    tertiary: Color(0xFF6BDBAD),
    onTertiary: Color(0xFF003826),
    tertiaryContainer: Color(0xFF005139),
    onTertiaryContainer: Color(0xFF88F8C8),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE3E2E6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE3E2E6),
    surfaceVariant: Color(0xFF44474F),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF8E9099),
    onInverseSurface: Color(0xFF1B1B1F),
    inverseSurface: Color(0xFFE3E2E6),
    inversePrimary: Color(0xFF005BC0),
    shadow: black,
    surfaceTint: Color(0xFFADC7FF),
    outlineVariant: Color(0xFF44474F),
    scrim: black,
  );
}
