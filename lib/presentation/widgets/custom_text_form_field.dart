import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.w,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty || value[0] == ' ') {
            return "يجب كتابه اسم الملف";
          } else {
            return null;
          }
        },
        controller: controller,
        style: AppStyle.bodyLarge(context),
        cursorColor: AppPalette.primaryColor,
        decoration: InputDecoration(
          errorStyle: AppStyle.bodyMedium(context).copyWith(color: Colors.red),
          border: const OutlineInputBorder(borderSide: BorderSide()),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppPalette.primaryColor)),
        ),
      ),
    );
  }
}
