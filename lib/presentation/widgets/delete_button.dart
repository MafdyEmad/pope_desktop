import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';

class DeleteButton extends StatelessWidget {
  final Widget child;
  final String path;
  final bool isDirectory;
  const DeleteButton({super.key, required this.child, required this.path, required this.isDirectory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
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
                context.read<AssetsBloc>().add(DeleteAssetsEvent(path, isDirectory));
              },
            ),
          ],
        );
      },
      child: child,
    );
  }
}
