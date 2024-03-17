import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/generated/assets.gen.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/app/themes/app_spacing.dart';
import 'package:pasa/core/presentation/widgets/pasa_button.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double widthFactor = 0.8; // 80% of screen width
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                SvgPicture.asset(
                  Assets.images.maintenance,
                  width: context.screenWidth * widthFactor,
                  height: context.screenWidth * widthFactor,
                ),
                const Spacer(),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Text(
                    'We Are Under Maintenance',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                Gap.xlarge(),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Text(
                    'Please check back soon just putting little touch up on some pretty updates.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ),
                const Spacer(),
                PasaButton(
                  buttonType: ButtonType.filled,
                  isExpanded: true,
                  text: context.i18n.common_exit.capitalize(),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                ),
                Gap.xxxlarge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
