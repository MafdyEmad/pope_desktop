import 'package:flutter/material.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core-old/share/app_api.dart';
import 'package:pope_desktop/core-old/utile/enums.dart';
import 'package:pope_desktop/presentation/widgets/delete_button.dart';
import 'package:pope_desktop/presentation/widgets/display_audio.dart';
import 'package:pope_desktop/presentation/widgets/display_image.dart';
import 'package:pope_desktop/presentation/widgets/display_pdf.dart';
import 'package:pope_desktop/presentation/widgets/display_video.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayAsset extends StatelessWidget {
  final AssetsState state;
  final int index;

  const DisplayAsset({super.key, required this.state, required this.index});

  @override
  Widget build(BuildContext context) {
    final path = '${state.folder.path}/${state.folder.files[index].name}';
    switch (state.folder.config.type) {
      case FilesType.image:
        return DeleteButton(
          isDirectory: false,
          path: path,
          child: GestureDetector(
            onTap: () {
              showDialog(
                useSafeArea: false,
                context: context,
                builder: (context) => AlertDialog(
                  content: DisplayImage(imagePath: path),
                  backgroundColor: Colors.transparent,
                ),
              );
            },
            child: DisplayImage(imagePath: path),
          ),
        );
      case FilesType.audio:
        return DeleteButton(
          isDirectory: false,
          path: path,
          child: DisplayAudio(imagePath: path),
        );
      case FilesType.pdf:
        return DeleteButton(
          isDirectory: false,
          path: path,
          child: GestureDetector(
            onTap: () async {
              if (await canLaunchUrl(Uri.parse('${API.explore}$path'))) {
                await launchUrl(Uri.parse('${API.explore}$path'));
              }
            },
            child: DisplayPDF(fileName: state.folder.files[index].name),
          ),
        );
      case FilesType.folder:
        return Container();
      case FilesType.video:
        return DisplayVideo(state: state);
    }
  }
}
