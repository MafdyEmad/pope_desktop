import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/app_api.dart';
import 'package:pope_desktop/core/share/snackbar.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/add_assets.dart';
import 'package:pope_desktop/presentation/widgets/create_colder.dart';
import 'package:pope_desktop/presentation/widgets/delete_button.dart';
import 'package:pope_desktop/presentation/widgets/display_audio.dart';
import 'package:pope_desktop/presentation/widgets/display_image.dart';
import 'package:pope_desktop/presentation/widgets/display_pdf.dart';
import 'package:pope_desktop/presentation/widgets/navigation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    context.read<AssetsBloc>().add(const LoadFoldersEvent('صور'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetsBloc, AssetsState>(
      listener: (context, state) {
        if (state.state == AssetState.failed) {
          showSnackBar(context, msg: state.msg);
        } else if (state.state == AssetState.success) {
          showSnackBar(context, msg: state.msg);
          context.read<AssetsBloc>().add(LoadFoldersEvent(state.folder.path));
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigationWidget(
                    title: "صور",
                    icon: Icons.image_outlined,
                    onPressed: () {
                      context.read<AssetsBloc>().add(const LoadFoldersEvent('صور'));
                    },
                  ),
                  NavigationWidget(
                    title: "صوت",
                    icon: Icons.music_video_outlined,
                    onPressed: () {
                      context.read<AssetsBloc>().add(const LoadFoldersEvent('صوت'));
                    },
                  ),
                  NavigationWidget(
                    title: "فيديو",
                    icon: Icons.video_file_outlined,
                    onPressed: () {},
                  ),
                  NavigationWidget(
                    title: "pdf",
                    icon: Icons.picture_as_pdf_outlined,
                    onPressed: () {
                      context.read<AssetsBloc>().add(const LoadFoldersEvent('pdf'));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: BlocBuilder<AssetsBloc, AssetsState>(
                builder: (context, state) {
                  if (state.state == AssetState.loaded || state.state == AssetState.failed) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (state.folder.path.split('/').length > 1) {
                                    context.read<AssetsBloc>().add(GoBackEvent(state.folder.path));
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                )),
                            Text(
                              state.folder.path,
                              style: AppStyle.bodyMedium(context),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                context.read<AssetsBloc>().add(LoadFoldersEvent(state.folder.path));
                              },
                              icon: const Icon(
                                Icons.refresh,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            color: AppPalette.foregroundColor,
                            child: GridView.builder(
                              itemCount: state.folder.files.length + 2,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                if (index == state.folder.files.length) {
                                  return CreateFolder(
                                    path: state.folder.path,
                                  );
                                } else if (index == state.folder.files.length + 1) {
                                  if (state.folder.path.isNotEmpty) {
                                    return AddAssets(path: state.folder.path);
                                  }
                                } else {
                                  if (state.folder.files[index].isDirectory) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<AssetsBloc>().add(LoadFoldersEvent(
                                            '${state.folder.path}/${state.folder.files[index].name}'));
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
                                  } else {
                                    final path = '${state.folder.path}/${state.folder.files[index].name}';
                                    switch (state.folder.path.split('/').first) {
                                      case 'صور':
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
                                      case 'صوت':
                                        return DeleteButton(
                                          isDirectory: false,
                                          path: path,
                                          child: DisplayAudio(imagePath: path),
                                        );
                                      case 'pdf':
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
                                    }
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state.state == AssetState.progress) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'جاري رفع الملف',
                          style: AppStyle.bodyMedium(context),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 12,
                          width: 150.w,
                          child: LinearProgressIndicator(
                            color: AppPalette.primaryColor,
                            value: state.progress,
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }

                  //
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
