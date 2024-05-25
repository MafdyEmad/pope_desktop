import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final void Function()? onPressed;
  const CustomButton({super.key, required this.text, this.isPrimary = true, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppPalette.primaryColor : AppPalette.foregroundColor,
        ),
        child: Text(
          text,
          style: AppStyle.bodyLarge(context).copyWith(color: isPrimary ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
