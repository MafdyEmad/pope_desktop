import 'package:flutter/material.dart';
import 'package:pope_desktop/core/util/extensions.dart';

class FileTypeOption extends StatelessWidget {
  const FileTypeOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: 0,
          groupValue: 0,
          onChanged: (_) {},
        ),
        Text(
          "مجلد",
          style: context.theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}
