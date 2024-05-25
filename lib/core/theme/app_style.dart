import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static const double _titleLargeSize = 40;
  static const double _bodyLargeSize = 25;

  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: _titleLargeSize.sp, color: Colors.black);

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: _bodyLargeSize.sp, color: Colors.black);
}
