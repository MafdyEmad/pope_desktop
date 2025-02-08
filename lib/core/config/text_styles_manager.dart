import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_palette.dart';

class TextStylesManager {
  // ******************************************** light ****************************************
  static TextStyle titleLargeLight = TextStyle(
    fontSize: 26.sp,
    fontFamily: 'STV',
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headlineLargeLight = TextStyle(
    fontSize: 22.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headlineMediumLight = TextStyle(
    fontSize: 20.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headlineSmallLight = TextStyle(
    fontSize: 18.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyLargeLight = TextStyle(
    fontSize: 20.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyMediumLight = TextStyle(
    fontSize: 18.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodySmallLight = TextStyle(
    fontSize: 16.sp,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.w400,
  );

  // ******************************************** dark ****************************************
  // static TextStyle titleLargeDark = TextStyle(
  //   fontSize: 22.sp,
  //   color: AppPalette.textBlack,
  //   fontWeight: FontWeight.w500,
  // );

  // static TextStyle headlineLargeDark = TextStyle(
  //   fontSize: 20.sp,
  //   color: AppPalette.textBlack,
  //   fontWeight: FontWeight.w600,
  // );
  // static TextStyle bodyLargeDark = TextStyle(
  //   fontSize: 18.sp,
  //   color: AppPalette.textSubtitleLight,
  //   fontWeight: FontWeight.w400,
  // );
  // static TextStyle bodyMediumDark = TextStyle(
  //   fontSize: 16.sp,
  //   color: AppPalette.textSubtitleLight,
  //   fontWeight: FontWeight.w400,
  // );
  // static TextStyle bodySmallDark = TextStyle(
  //   fontSize: 14.sp,
  //   color: AppPalette.textSubtitleLight,
  //   fontWeight: FontWeight.w400,
  // );
}
