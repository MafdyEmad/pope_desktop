import 'package:flutter/material.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/extensions.dart';

void showSnackBar(BuildContext context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppPalette.appBare,
    content: Text(
      text,
      style: context.theme.textTheme.headlineLarge,
    ),
    duration: const Duration(seconds: 2),
  ));
}
