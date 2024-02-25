import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasa/core/presentation/widgets/pasa_info_text_field.dart';

import '../../../utils/test_utils.dart';

void main() {
  group(PasaInfoTextField, () {
    goldenTest(
      'renders correctly',
      fileName: 'pasa_info_text_field'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default(expanded)',
            constraints: const BoxConstraints(minWidth: 200),
            child: const PasaInfoTextField(
              title: 'Title',
              description: 'Description',
            ),
          ),
          GoldenTestScenario(
            name: 'shrink',
            child: const PasaInfoTextField(
              title: 'Title',
              description: 'Description',
              isExpanded: false,
            ),
          ),
        ],
      ),
    );
  });
}
