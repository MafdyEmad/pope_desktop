import 'package:flutter/material.dart';
import 'package:pope_desktop/core/config/app_palette.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppPalette.primary,
      ),
    );
  }
}
