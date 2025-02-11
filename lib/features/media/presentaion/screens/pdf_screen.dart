import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/extensions.dart';
import 'package:pope_desktop/features/explorer/data/models/folder_content.dart';
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
                  itemBuilder: (context, index) => const ListTile(
                    title: Text('data'),
                    leading: Icon(Icons.picture_as_pdf),
                  ),
                );
        },
      ),
    );
  }
}
