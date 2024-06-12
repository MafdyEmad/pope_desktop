import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/snackbar.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/core/utile/extensions.dart';
import 'package:pope_desktop/presentation/widgets/add_assets.dart';
import 'package:pope_desktop/presentation/widgets/create_colder.dart';
import 'package:pope_desktop/presentation/widgets/display_asset.dart';
import 'package:pope_desktop/presentation/widgets/display_directory.dart';
import 'package:pope_desktop/presentation/widgets/display_saying.dart';

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
        if (state.state == AssetState.failed) {
          showSnackBar(context, msg: state.msg);
        } else if (state.state == AssetState.success) {
          showSnackBar(context, msg: state.msg);
          context.read<AssetsBloc>().add(LoadFoldersEvent(state.folder.path));
        }
      },
      child: Scaffold(
        body: BlocBuilder<AssetsBloc, AssetsState>(
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
                        ),
                      ),
                      Text(
                        state.folder.path.cleanPath(),
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
                      IconButton(
                        onPressed: () {
                          context.read<AssetsBloc>().add(const LoadFoldersEvent(''));
                        },
                        icon: const Icon(
                          Icons.home,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: AppPalette.foregroundColor,
                      child: state.folder.path.contains('اقوال يومية')
                          ? DisplaySaying(state: state)
                          : GridView.builder(
                              itemCount: state.folder.path.isEmpty
                                  ? state.folder.files.length
                                  : state.folder.files.length + 1,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                if (index < state.folder.files.length) {
                                  if (state.folder.files[index].isDirectory) {
                                    return DisplayDirectory(state: state, index: index);
                                  } else {
                                    return DisplayAsset(state: state, index: index);
                                  }
                                } else {
                                  if (state.folder.directoryType == "مجلد") {
                                    return CreateFolder(
                                      path: state.folder.path,
                                    );
                                  } else if (state.folder.directoryType != "فيديو") {
                                    return AddAssets(
                                      fileLength: state.folder.files.length,
                                      path: state.folder.path,
                                      type: state.folder.directoryType,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
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
          },
        ),
      ),
    );
  }
}
