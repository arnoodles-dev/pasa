import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const String svgStr = '''<svg viewBox="0 0 10 10"></svg>''';

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async => svgStr;

  @override
  Future<ByteData> load(String key) async =>
      Uint8List.fromList(utf8.encode(svgStr)).buffer.asByteData();
}
