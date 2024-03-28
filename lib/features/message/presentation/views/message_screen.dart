import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Colors.green,
        child: Center(
          child: Text('MessageScreen'),
        ),
      );
}
