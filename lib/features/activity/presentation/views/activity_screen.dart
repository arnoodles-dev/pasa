import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Colors.blue,
        child: Center(
          child: Text('ActivityScreen'),
        ),
      );
}
