import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/delete_button.dart';

class DisplayDirectory extends StatelessWidget {
  final AssetsState state;
  final int index;

  const DisplayDirectory({super.key, required this.state, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<AssetsBloc>()
            .add(LoadFoldersEvent('${state.folder.path}/${state.folder.files[index].name}'));
      },
      child: DeleteButton(
        isDirectory: true,
        path: '${state.folder.path}/${state.folder.files[index].name}',
        child: Container(
          color: AppPalette.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_outlined,
                size: 80,
              ),
              Text(
                state.folder.files[index].name,
                style: AppStyle.bodyLarge(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
