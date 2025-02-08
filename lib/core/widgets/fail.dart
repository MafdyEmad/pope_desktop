import 'package:flutter/material.dart';
import 'package:pope_desktop/core/util/extensions.dart';

class Fail extends StatelessWidget {
  final String message;
  const Fail({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.theme.textTheme.headlineLarge,
      ),
    );
  }
}
