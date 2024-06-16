import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/core/utile/enums.dart';
import 'package:pope_desktop/core/utile/extensions.dart';

class AddAssets extends StatelessWidget {
  final String path;
  final FilesType type;
  final int fileLength;
  const AddAssets({super.key, required this.path, required this.type, required this.fileLength});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<AssetsBloc>().add(UploadAssetsEvent(path, type, fileLength));
      },
      child: DottedBorder(
        strokeCap: StrokeCap.square,
        strokeWidth: 2,
        dashPattern: const [1, 10],
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                size: 80,
              ),
              Text(
                "اضافه ${type.getName}",
                style: AppStyle.bodyLarge(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
