import 'package:flutter/material.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';

void showWindow(context, {Widget? content, List<Widget>? actions, required String title}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: content,
      title: Text(title, style: AppStyle.titleLarge(context)),
      actions: actions,
      backgroundColor: AppPalette.backgroundColor,
    ),
  );
}
