import 'package:flutter/material.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';

void showSnackBar(context, {String? msg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppPalette.backgroundColor,
      behavior: SnackBarBehavior.floating,
      width: 600,
      content: Center(child: Text(msg!, style: AppStyle.bodyLarge(context))),
      duration: const Duration(seconds: 2),
    ),
  );
}
