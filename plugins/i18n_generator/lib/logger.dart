// ignore_for_file: always_specify_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

class Logger {
  factory Logger() => _instance ??= Logger._();

  Logger._();

  static Logger? _instance;

  bool isDebug = false;

  void debug(Object msg) {
    if (isDebug) {
      log(msg.toString());
    }
  }
}
