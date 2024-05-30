import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 40.sp, color: Colors.black);

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 25.sp, color: Colors.black);
  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22.sp, color: Colors.black);
  static TextStyle bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, color: Colors.black);
}
