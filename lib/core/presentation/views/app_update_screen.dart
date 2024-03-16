import 'package:flutter/material.dart';
import 'package:pasa/app/helpers/extensions/build_context_ext.dart';
import 'package:pasa/core/presentation/widgets/app_title.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.background,
        body: const SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Center(
                    child: AppTitle(),
                  ),
                ),
                Flexible(
                  child: ColoredBox(
                    color: Colors.blue,
                    child: Text('APP UPDATE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}