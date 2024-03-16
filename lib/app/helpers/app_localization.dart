import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pasa/app/generated/app_localization_lookup.gen.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

typedef LocaleChangeCallback = void Function(Locale locale);

class AppLocalization
    with AppLocalizationLookup
    implements WidgetsLocalizations {
  factory AppLocalization() => _instance;

  AppLocalization._internal();

  static final AppLocalization _instance = AppLocalization._internal();

  static Locale? _locale;
  static bool _shouldReload = false;

  static set locale(Locale? newLocale) {
    _shouldReload = true;
    AppLocalization._locale = newLocale;
  }

  static Locale? get locale => _locale;

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  /// function to be invoked when changing the language
  static late LocaleChangeCallback onLocaleChanged;

  static AppLocalization of(BuildContext context) {
    late AppLocalization instance;
    try {
      instance =
          Localizations.of<AppLocalization>(context, WidgetsLocalizations)!;
    } catch (e) {
      instance = _instance;
    }
    return instance;
  }

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get reorderItemDown => "To Down";

  @override
  String get reorderItemLeft => "To Left";

  @override
  String get reorderItemRight => "To Right";

  @override
  String get reorderItemToEnd => "To End";

  @override
  String get reorderItemToStart => "To Start";

  @override
  String get reorderItemUp => "To Up";
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const AppLocalizationsDelegate();
  List<Locale> get supportedLocales => const <Locale>[Locale('en', 'US')];

  LocaleResolutionCallback resolution({Locale? fallback}) =>
      (Locale? locale, Iterable<Locale> supported) {
        if (isSupported(locale)) {
          return locale;
        }
        final Locale fallbackLocale = fallback ?? supported.first;
        return fallbackLocale;
      };

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    AppLocalization._locale ??= locale;
    AppLocalization._shouldReload = false;
    final String lang = AppLocalization._locale?.toString() ?? 'en_US';
    final String languageCode = AppLocalization._locale?.languageCode ?? 'en';

    if ('en_US' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(AppLocalization());
    } else if ('en' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(AppLocalization());
    }

    return SynchronousFuture<WidgetsLocalizations>(AppLocalization());
  }

  @override
  bool isSupported(Locale? locale) {
    for (int i = 0; i < supportedLocales.length && locale != null; i++) {
      final Locale l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) =>
      AppLocalization._shouldReload;
}
