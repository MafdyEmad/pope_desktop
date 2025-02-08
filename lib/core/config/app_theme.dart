import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/config/text_styles_manager.dart';

const String fontFamily = 'STV';

class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppPalette.iconButtonColor,
    ),
    scaffoldBackgroundColor: AppPalette.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.appBare,
      surfaceTintColor: Colors.transparent,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        // backgroundColor: AppPalette.iconButtonColor,
        iconSize: 35.sp,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppPalette.primary,
      selectionColor: AppPalette.primary.withAlpha(100),
    ),
    radioTheme: const RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppPalette.primary),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.primary, width: 2),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.primary),
      ),
    ),
    iconTheme: const IconThemeData(color: AppPalette.primary),
    primaryColor: AppPalette.primary,
    textTheme: TextTheme(
      titleLarge: TextStylesManager.titleLargeLight,
      headlineLarge: TextStylesManager.headlineLargeLight,
      headlineMedium: TextStylesManager.headlineMediumLight,
      headlineSmall: TextStylesManager.headlineSmallLight,
      bodyLarge: TextStylesManager.bodyLargeLight,
      bodyMedium: TextStylesManager.bodyMediumLight,
      bodySmall: TextStylesManager.bodySmallLight,
    ),
  );
}
