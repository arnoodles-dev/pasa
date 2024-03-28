import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path_library;

import 'builder.dart';
import 'logger.dart';

// ignore_for_file: always_specify_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: depend_on_referenced_packages
String get separator => path_library.separator;

void main(List<String> args) {
  final ArgParser parser = ArgParser()
    ..addFlag(
      'watch',
      abbr: 'w',
      help: 'Continue to monitor changes after execution of orders.',
    )
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'lib${separator}const${separator}resource.dart',
      help:
          "Your resource file path. \nIf it's a relative path, the relative flutter root directory",
    )
    ..addOption(
      'src',
      abbr: 's',
      defaultsTo: Platform.isMacOS ? '' : '.',
      help: 'Flutter project root path',
    )
    ..addFlag('help', abbr: 'h', help: 'Help usage')
    ..addFlag('debug', abbr: 'd', help: 'debug info');

  final results = parser.parse(args);

  Logger().isDebug = results['debug'] as bool;

  if (results.wasParsed('help')) {
    log(parser.usage);
    return;
  }

  final String path = results['src'] as String;
  final String outputPath = results['output'] as String;
  final workPath = File(path).absolute;
  log('Generate files for Project : ${workPath.absolute.path}');

  resourceDartBuilder(workPath, outputPath, isWatch: results['watch'] as bool);
}
