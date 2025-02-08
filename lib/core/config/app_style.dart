import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static const double _titleLargeSize = 22;
  static const double _bodyLargeSize = 20;
  static const double _bodyMediumSize = 18;
  static const double _bodySmallSize = 16;

  static TextStyle titleLarge(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: _titleLargeSize.sp);
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: _bodyLargeSize.sp);
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: _bodyMediumSize.sp);
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: _bodySmallSize.sp);
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: _titleLargeSize.sp);
  }
}
