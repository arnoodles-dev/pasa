import 'package:flutter/material.dart';
import 'package:pasa/core/presentation/widgets/connectivity_checker.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) => ConnectivityChecker.scaffold(
        appBar: AppBar(),
        body: const ColoredBox(
          color: Colors.orange,
          child: Center(
            child: Text('CREATE POST'),
          ),
        ),
      );
}
