import 'package:flutter/material.dart';
import 'package:pope_desktop/core/theme/app_style.dart';

class NavigationWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onPressed;
  const NavigationWidget({super.key, required this.title, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 50,
          ),
        ),
        Text(
          title,
          style: AppStyle.bodyMedium(context),
        ),
      ],
    );
  }
}
