import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/app_api.dart';
import 'package:pope_desktop/core/share/snackbar.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/cubit/image_cubit/image_cubit.dart';
import 'package:pope_desktop/presentation/widgets/add_assets.dart';
import 'package:pope_desktop/presentation/widgets/create_colder.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    context.read<AssetsBloc>().add(const LoadFoldersEvent(''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetsBloc, AssetsState>(
      listener: (context, state) {
        if (state.state == States.failed) {
          showSnackBar(context, msg: state.msg);
        } else if (state.state == States.success) {
          showSnackBar(context, msg: state.msg);
          context.read<AssetsBloc>().add(LoadFoldersEvent(state.folder.path));
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image_outlined,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.music_video_outlined,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.video_file_outlined,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: BlocBuilder<AssetsBloc, AssetsState>(
                buildWhen: (previous, current) =>
                    current.state == States.loaded || current.state == States.loading,
                builder: (context, state) {
                  if (state.state == States.loaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<AssetsBloc>().add(GoBackEvent(state.folder.path));
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                )),
                            Text(
                              state.folder.path.isEmpty
                                  ? 'الصفحه الرئيسيه'
                                  : "الصفحه الرئيسيه ${state.folder.path}",
                              style: AppStyle.bodyMedium(context),
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
                                  return const AddAssets();
                                } else {
                                  if (state.folder.files[index].isDirectory) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<AssetsBloc>().add(LoadFoldersEvent(
                                            '${state.folder.path}/${state.folder.files[index].name}'));
                                      },
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
                                    );
                                  } else {
                                    return Image.network('${API.explore}${state.folder.files[index].name}');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
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
