import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasa/core/domain/entity/value_object.dart';
import 'package:pasa/core/presentation/widgets/pasa_text_url.dart';

import '../../../utils/test_utils.dart';

void main() {
  group(PasaTextUrl, () {
    int count = 0;
    const String url = 'https://www.example.com';
    goldenTest(
      'renders correctly',
      fileName: 'pasa_text_url'.goldensVersion,
      constraints: const BoxConstraints(minWidth: 200),
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: SizedBox(
              height: 20,
              child: PasaTextUrl(
                url: Url(url),
                onTap: () => count++,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'no icon',
            child: SizedBox(
              height: 20,
              child: PasaTextUrl(
                url: Url(url),
                onTap: () => count++,
                isShowIcon: false,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
