import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasa/features/auth/presentation/views/login_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';

void main() {
  Widget buildLoginScreen() => const MockMaterialApp(
        child: LoginScreen(),
      );

  group(LoginScreen, () {
    goldenTest(
      'renders correctly',
      fileName: 'login_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pumpAndSettle(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: buildLoginScreen,
          ),
        ],
      ),
    );
  });
}
