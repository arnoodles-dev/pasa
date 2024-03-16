import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pasa/app/helpers/app_localization.dart';

class MockLocalization extends StatelessWidget {
  const MockLocalization({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Localizations(
        locale: const Locale('en'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: child,
      );
}
