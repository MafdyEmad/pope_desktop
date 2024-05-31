import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/theme/app_style.dart';

class AddAssets extends StatelessWidget {
  final String path;
  const AddAssets({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<AssetsBloc>().add(UploadAssetsEvent(path));
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
                "اضافه ${path.split('/').first}",
                style: AppStyle.bodyLarge(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
