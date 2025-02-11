import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/extensions.dart';
import 'package:pope_desktop/features/explorer/data/models/folder_content.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/presentaion/bloc/media_bloc.dart';

class PdfScreen extends StatelessWidget {
  final String path;
  final String folderId;
  final List<FolderContent> folderContent;
  const PdfScreen({super.key, required this.folderContent, required this.path, required this.folderId});

  Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = await pickFile();
          if (file != null) {
            context.read<MediaBloc>().add(
                  UploadMedia(
                    filePicker: file,
                    path: path,
                    folderId: folderId,
                  ),
                );
          }
        },
        child: const Icon(
          Icons.post_add,
          color: AppPalette.card,
        ),
      ),
      body: BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          if (state is MediaUploading) {
            return Text(state.progress.toString());
          }

          return folderContent.isEmpty
              ? Center(
                  child: Text(
                    'لا يوجد PDF',
                    style: context.theme.textTheme.headlineLarge,
                  ),
                )
              : ListView.separated(
                  itemCount: folderContent.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              'هل انت متأكد انك تريد حذف الملف',
                              style: context.theme.textTheme.headlineLarge,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'الغاء',
                                  style: context.theme.textTheme.headlineLarge,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<MediaBloc>().add(
                                        DeleteMedia(id: folderContent[index].id),
                                      );
                                  Timer(const Duration(milliseconds: 500), () {
                                    context
                                        .read<ExplorerBloc>()
                                        .add(ExploreEvent(folderPath: path.removeBaseRoute));
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'حذف',
                                  style: context.theme.textTheme.headlineLarge?.copyWith(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    title: Text(folderContent[index].name),
                    leading: const Icon(Icons.picture_as_pdf),
                  ),
                );
        },
      ),
    );
  }
}
