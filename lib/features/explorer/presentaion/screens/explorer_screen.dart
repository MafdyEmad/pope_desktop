import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/enums.dart';
import 'package:pope_desktop/core/util/extensions.dart';
import 'package:pope_desktop/core/util/snackbar.dart';
import 'package:pope_desktop/core/widgets/fail.dart';
import 'package:pope_desktop/core/widgets/loading.dart';
import 'package:pope_desktop/features/explorer/presentaion/bloc/explorer_bloc.dart';
import 'package:pope_desktop/features/media/presentaion/screens/media_screen.dart';
import 'package:pope_desktop/features/sayings/ui/screens/sayings_screen.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final TextEditingController _fileNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> folders = [
    'مكتبة الكتب',
    'مكتبة الفيديو',
    'مكتبة الصور',
    'مقالات واشعار',
    'ذكريات عن قداستة',
    'المكتبة الصوتية',
    'المزار',
    'اقوال مصورة',
    'اقوال يومية',
  ];
  MediaType selectedType = MediaType.folder;
  void _changeType(type, setState) {
    selectedType = type;
    setState(() {});
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExplorerBloc, ExplorerState>(
      buildWhen: (previous, current) =>
          current is ExplorerInitial ||
          current is ExplorerExploreFail ||
          current is ExplorerExploreLoading ||
          current is ExplorerExploreSuccess,
      listener: (context, state) {
        if (state is CRUDFolderFail) {
          Navigator.pop(context);
          showSnackBar(context, text: state.message);
        } else if (state is CRUDFolderSuccess) {
          Navigator.pop(context);
          showSnackBar(context, text: state.message);
        } else if (state is CRUDFolderLoading) {
          Navigator.pop(context);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const Loading(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: state is ExplorerInitial ||
                  (state is ExplorerExploreSuccess && state.folder.folderType != MediaType.folder.name)
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => StatefulBuilder(
                        builder: (_, setState) => AlertDialog(
                          title: Text(
                            'اضافة',
                            style: context.theme.textTheme.headlineLarge,
                          ),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "الأسم",
                                  style: context.theme.textTheme.headlineMedium,
                                ),
                                TextFormField(
                                  controller: _fileNameController,
                                  validator: (value) {
                                    if (_fileNameController.text.isEmpty) {
                                      return 'يجب ادخال اسم الملف';
                                    }
                                    return null;
                                  },
                                  cursorColor: AppPalette.primary,
                                ),
                                Text(
                                  "النوع",
                                  style: context.theme.textTheme.headlineMedium,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            value: MediaType.folder,
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              _changeType(value, setState);
                                            },
                                            title: Text(
                                              'مجلد',
                                              style: context.theme.textTheme.headlineMedium,
                                            ),
                                          ),
                                          RadioListTile(
                                            value: MediaType.image,
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              _changeType(value, setState);
                                            },
                                            title: Text(
                                              'صور',
                                              style: context.theme.textTheme.headlineMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            value: MediaType.video,
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              _changeType(value, setState);
                                            },
                                            title: Text(
                                              'فيديو',
                                              style: context.theme.textTheme.headlineMedium,
                                            ),
                                          ),
                                          RadioListTile(
                                            value: MediaType.audio,
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              _changeType(value, setState);
                                            },
                                            title: Text(
                                              'صوت',
                                              style: context.theme.textTheme.headlineMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        value: MediaType.pdf,
                                        groupValue: selectedType,
                                        onChanged: (value) {
                                          _changeType(value, setState);
                                        },
                                        title: Text(
                                          'PDF',
                                          style: context.theme.textTheme.headlineMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppPalette.primary,
                                    ),
                                    onPressed: () {
                                      if (state is ExplorerExploreSuccess) {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<ExplorerBloc>().add(
                                                CreateFolderEvent(
                                                  folderName: _fileNameController.text.trim(),
                                                  folderPath: state.folder.folderPath.removeBaseRoute,
                                                  folderType: selectedType.name,
                                                ),
                                              );
                                          Timer(const Duration(milliseconds: 500), () {
                                            context.read<ExplorerBloc>().add(ExploreEvent(
                                                folderPath: state.folder.folderPath.removeBaseRoute));
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'اضافة',
                                      style: context.theme.textTheme.headlineMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).then((_) {
                      _fileNameController.clear();
                      selectedType = MediaType.folder;
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppPalette.appBare,
                  ),
                ),
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (state is ExplorerInitial) return;
                  if (state is ExplorerExploreSuccess) {
                    final path = state.folder.folderPath.removeBaseRoute.split('/');
                    if (path.length == 1) {
                      context.read<ExplorerBloc>().add(GoHomeEvent());
                      return;
                    }
                    path.removeLast();

                    context.read<ExplorerBloc>().add(ExploreEvent(folderPath: path.join('/')));
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                )),
            title: Text(
              state is ExplorerExploreSuccess ? state.folder.folderPath.removeBaseRoute : '',
              style: context.theme.textTheme.headlineLarge,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ExplorerBloc>().add(GoHomeEvent());
                },
                icon: const Icon(
                  Icons.home,
                ),
              ),
            ],
          ),
          body: Builder(builder: (context) {
            if (state is ExplorerInitial) {
              return ListView.separated(
                itemCount: folders.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    minTileHeight: 80,
                    onTap: () {
                      if (index == folders.length - 1) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const SayingsScreen()));
                        return;
                      }
                      context.read<ExplorerBloc>().add(ExploreEvent(folderPath: folders[index]));
                    },
                    leading: Icon(
                      index == folders.length - 1 ? Icons.comment : Icons.folder,
                      size: 50,
                    ),
                    title: Text(
                      folders[index],
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  );
                },
              );
            }
            if (state is ExplorerExploreSuccess) {
              final content = state.folder.folderContent;
              if (state.folder.folderType != MediaType.folder.name) {
                return MediaScreen(
                    folderContent: content,
                    path: state.folder.folderPath,
                    folderId: state.folder.folderId,
                    type: MediaType.values.firstWhere(
                      (e) => e.name.toLowerCase() == state.folder.folderType.toLowerCase(),
                    ));
              }
              if (content.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد ملفات',
                    style: context.theme.textTheme.headlineLarge,
                  ),
                );
              }
              return ListView.separated(
                itemCount: content.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 30.h,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    // subtitle: Text(
                    //   state.folder.folderType,
                    //   style: context.theme.textTheme.headlineSmall,
                    // ),
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
                                  context.read<ExplorerBloc>().add(
                                        DeleteFolderEvent(folderId: content[index].id),
                                      );
                                  Timer(const Duration(milliseconds: 500), () {
                                    context.read<ExplorerBloc>().add(
                                        ExploreEvent(folderPath: state.folder.folderPath.removeBaseRoute));
                                  });
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
                    minTileHeight: 80,
                    onTap: () {
                      context
                          .read<ExplorerBloc>()
                          .add(ExploreEvent(folderPath: content[index].path.removeBaseRoute));
                    },
                    leading: Icon(
                      index == folders.length - 1 ? Icons.comment : Icons.folder,
                      size: 50.r,
                    ),
                    title: Text(
                      content[index].name,
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  );
                },
              );
            } else if (state is ExplorerExploreFail) {
              return Fail(message: state.message);
            } else {
              return const Loading();
            }
          }),
        );
      },
    );
  }
}
