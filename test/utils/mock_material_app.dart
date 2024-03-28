import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pasa/app/constants/constant.dart';
import 'package:pasa/app/helpers/app_localization.dart';
import 'package:pasa/app/themes/app_theme.dart';

class MockMaterialApp extends StatelessWidget {
  const MockMaterialApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: child,
        title: Constant.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        supportedLocales: AppLocalization.delegate.supportedLocales,
        localeResolutionCallback: AppLocalization.delegate.resolution(
          fallback: const Locale('en', 'US'),
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
      );
}
