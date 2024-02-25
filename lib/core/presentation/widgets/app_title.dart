import 'package:flutter/material.dart';
import 'package:pasa/app/constants/constant.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        textAlign: TextAlign.center,
        style: context.textTheme.displayLarge
            ?.copyWith(color: context.colorScheme.primary),
      );
}
