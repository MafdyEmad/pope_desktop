import 'package:flutter/material.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    radioTheme: const RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppPalette.primaryColor),
    ));
