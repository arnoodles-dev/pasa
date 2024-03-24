import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/core/presentation/widgets/pasa_icon.dart';

import '../../../utils/mock_asset_bundle.dart';
import '../../../utils/test_utils.dart';

void main() {
  group(PasaIcon, () {
    Widget buildIcon(Either<String, IconData> icon) => DefaultAssetBundle(
          bundle: MockAssetBundle(),
          child: PasaIcon(
            icon: icon,
          ),
        );
    goldenTest(
      'renders correctly',
      fileName: 'pasa_icon'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'svg icon',
            child: buildIcon(
              left(Assets.icons.launcherIcon.path),
            ),
          ),
          GoldenTestScenario(
            name: 'material icon',
            child: buildIcon(
              right(Icons.abc),
            ),
          ),
        ],
      ),
    );
  });
}
