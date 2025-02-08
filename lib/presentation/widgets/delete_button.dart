import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core-old/share/show_dialog.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/custom_button.dart';

class DeleteButton extends StatelessWidget {
  final Widget child;
  final String path;
  final bool isDirectory;
  final void Function()? onPressed;
  const DeleteButton(
      {super.key, required this.child, required this.path, required this.isDirectory, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        if (path.split('/').length == 2 && path.split('/')[0].isEmpty) {
          return;
        }

        showMenu(
          color: AppPalette.foregroundColor,
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx + 10,
            details.globalPosition.dy + 10,
          ),
          items: [
            PopupMenuItem(
              value: 'حذف',
              child: const Text('حذف'),
              onTap: () {
                showWindow(context,
                    title: 'حذف الملف',
                    content: Text(
                      'هل انت متأكد انك تريد حذف هذا الملف',
                      style: AppStyle.bodySmall(context),
                    ),
                    actions: [
                      CustomButton(
                        text: 'حذف',
                        isPrimary: true,
                        onPressed: onPressed ??
                            () {
                              context.read<AssetsBloc>().add(DeleteAssetsEvent(path, isDirectory));
                              Navigator.pop(context);
                            },
                      ),
                      CustomButton(
                          isPrimary: false,
                          text: 'الغاء',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ]);
              },
            ),
          ],
        );
      },
      child: child,
    );
  }
}
