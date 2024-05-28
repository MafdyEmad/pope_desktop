import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/data_provider/folder_provider.dart';

class AddAssets extends StatelessWidget {
  const AddAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<AssetsBloc>().add(const UploadAssetsEvent(''));
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
                Icons.image,
                size: 80,
              ),
              Text(
                "اضافه صوره",
                style: AppStyle.bodyLarge(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
