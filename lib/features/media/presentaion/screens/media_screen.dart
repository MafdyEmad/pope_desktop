import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:pope_desktop/core/util/enums.dart';
import 'package:pope_desktop/core/util/extensions.dart';
import 'package:pope_desktop/core/widgets/loading.dart';
import 'package:pope_desktop/features/explorer/data/models/folder_content.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/presentaion/bloc/media_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaScreen extends StatefulWidget {
  final String path;
  final String folderId;
  final List<FolderContent> folderContent;
  final MediaType type;
  const MediaScreen(
      {super.key,
      required this.path,
      required this.folderId,
      required this.folderContent,
      required this.type});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  Timer? _timer;
  Future<FilePickerResult?> pickFile() async {
    final FileType fileType = switch (widget.type) {
      MediaType.audio => FileType.audio,
      MediaType.pdf => FileType.custom,
      _ => FileType.image,
    };
    return await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fileType,
      allowedExtensions: widget.type == MediaType.pdf ? ['pdf'] : null,
    );
  }

  final _linkController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _timer?.cancel();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (widget.type == MediaType.video) {
          if (widget.folderContent.isNotEmpty) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "اضافة فيديو",
                style: context.theme.textTheme.titleLarge,
              ),
              content: SizedBox(
                width: context.screenWidth * .3,
                child: Form(
                  key: _form,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "لينك الفيديو",
                        style: context.theme.textTheme.headlineLarge,
                      ),
                      TextFormField(
                        controller: _linkController,
                        validator: (value) {
                          final regex = RegExp(r"(?:youtube\.com|youtu\.be).*?list=([a-zA-Z0-9_-]+)");
                          if (_linkController.text.trim().isEmpty) {
                            return 'برجاء اضافة لينك الفيديوهات';
                          } ////////////////////////////////////////////////////////////!!
                          if (regex.hasMatch(_linkController.text)) {
                            return ' برجاء ادخال لينك صالح';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'الغاء',
                    style: context.theme.textTheme.headlineMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      context
                          .read<MediaBloc>()
                          .add(AddYoutubeLink(_linkController.text, widget.path.removeBaseRoute));

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'اضافة',
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                      color: AppPalette.primary,
                    ),
                  ),
                ),
              ],
            ),
          ).then((_) => _linkController.clear());

          return;
        }
        final file = await pickFile();
        if (file != null) {
          context.read<MediaBloc>().add(
                UploadMedia(
                  filePicker: file,
                  path: widget.path,
                  folderId: widget.folderId,
                ),
              );
        }
      }, child: Builder(
        builder: (context) {
          return switch (widget.type) {
            MediaType.pdf => const Icon(
                Icons.post_add,
                color: AppPalette.card,
              ),
            MediaType.audio => const Icon(
                Icons.audio_file,
                color: AppPalette.card,
              ),
            MediaType.image => const Icon(
                Icons.image,
                color: AppPalette.card,
              ),
            MediaType.video => const Icon(
                Icons.video_file_rounded,
                color: AppPalette.card,
              ),
            _ => Container(),
          };
        },
      )),
      body: BlocConsumer<MediaBloc, MediaState>(
        listener: (context, state) {
          if (state is UploadLinkSuccess || state is MediaUpLoadingUpSuccess) {
            context.read<ExplorerBloc>().add(ExploreEvent(folderPath: widget.path.removeBaseRoute));
          }
        },
        builder: (context, state) {
          if (state is MediaUploading) {
            return Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'يتم رفع ${state.progress.total + 1} ملف من ${state.progress.index + 1} ملفات',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: context.screenWidth * .4,
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      color: AppPalette.primary,
                      value: state.progress.progress,
                    ),
                  ),
                  Text(
                    '${(state.progress.progress * 100).toInt().toString()}%',
                    style: context.theme.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          if (state is UploadLinkLoading) {
            return const Loading();
          }
          return Builder(
            builder: (context) {
              if (widget.folderContent.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد ملفات',
                    style: context.theme.textTheme.headlineLarge,
                  ),
                );
              }
              if (widget.type == MediaType.pdf) {
                return _displayPDF;
              }
              if (widget.type == MediaType.image) {
                return _displayImage;
              }
              if (widget.type == MediaType.video) {
                return _displayVideo;
              }
              if (widget.type == MediaType.audio) {
                return _displayAudio;
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  void deleteFileDialog(String id, [bool isLink = false]) {
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
              _timer?.cancel();
              context.read<MediaBloc>().add(
                    DeleteMedia(id: id, isLink: isLink),
                  );
              _timer = Timer(const Duration(milliseconds: 500), () {
                context.read<ExplorerBloc>().add(ExploreEvent(folderPath: widget.path.removeBaseRoute));
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
  }

  Widget get _displayPDF => ListView.separated(
        itemCount: widget.folderContent.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            launchUrl(Uri.parse(
                '${Constants.displayFile}${widget.path.removeBaseRoute}/${widget.folderContent.first.name}'));
          },
          trailing: IconButton(
            onPressed: () {
              deleteFileDialog(widget.folderContent[index].id);
            },
            icon: const Icon(Icons.delete),
          ),
          title: Text(
            widget.folderContent[index].name,
            style: context.theme.textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.picture_as_pdf),
        ),
      );

  Widget get _displayImage => GridView.builder(
        itemCount: widget.folderContent.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onSecondaryTapDown: (details) {
              showMenu(
                color: AppPalette.background,
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
                      deleteFileDialog(widget.folderContent[index].id);
                    },
                  ),
                ],
              );
            },
            child: Image.network(
              '${Constants.displayFile}${widget.path.removeBaseRoute}/${widget.folderContent[index].name}',
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.not_interested),
            ),
          );
        },
      );
  Widget get _displayVideo {
    return ListTile(
      onTap: () {
        try {
          launchUrl(Uri.parse(
              '${Constants.displayFile}${widget.path.removeBaseRoute}/${widget.folderContent.first.name}'));
        } catch (_) {}
      },
      title: Text(
        widget.folderContent.first.name,
        style: context.theme.textTheme.headlineMedium,
      ),
      trailing: IconButton(
        onPressed: () {
          deleteFileDialog(widget.folderContent.first.id, true);
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }

  Widget get _displayAudio => ListView.separated(
        itemCount: widget.folderContent.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            try {
              launchUrl(Uri.parse(
                  '${Constants.displayFile}${widget.path.removeBaseRoute}/${widget.folderContent[index].name}'));
            } catch (_) {}
          },
          trailing: IconButton(
            onPressed: () {
              deleteFileDialog(widget.folderContent[index].id);
            },
            icon: const Icon(Icons.delete),
          ),
          title: Text(
            widget.folderContent[index].name,
            style: context.theme.textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.audiotrack_rounded),
        ),
      );
}
