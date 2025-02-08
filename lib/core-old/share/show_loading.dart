import 'package:flutter/material.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';

void showLoading(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const AlertDialog(
      content: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      backgroundColor: AppPalette.backgroundColor,
    ),
  );
}
