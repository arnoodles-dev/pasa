import 'package:yaml/yaml.dart';

// ignore_for_file: depend_on_referenced_packages
class I18nConfig {
  I18nConfig(
    this.defaultLocale,
    this.localePath,
    this.generatedPath,
    this.locales,
    this.ltr,
    this.rtl,
  );

  I18nConfig.fromYaml(YamlMap yaml)
      : defaultLocale = yaml['defaultLocale'] as String,
        localePath = yaml['localePath'] as String,
        generatedPath = yaml['generatedPath'] as String,
        locales = yaml['locales'] as YamlList?,
        ltr = yaml['ltr'] as YamlList?,
        rtl = yaml['rtl'] as YamlList?;

  final String defaultLocale;
  final String localePath;
  final String generatedPath;
  final YamlList? locales;
  final YamlList? ltr;
  final YamlList? rtl;
}
