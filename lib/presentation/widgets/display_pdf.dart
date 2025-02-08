import 'package:flutter/material.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';

class DisplayPDF extends StatelessWidget {
  final String fileName;
  const DisplayPDF({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.picture_as_pdf_outlined,
          size: 80,
        ),
        Text(
          fileName,
          maxLines: 3,
          style: AppStyle.bodyMedium(context),
        ),
      ],
    );
  }
}
