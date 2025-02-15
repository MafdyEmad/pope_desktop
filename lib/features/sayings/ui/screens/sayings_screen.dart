import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/core/config/app_palette.dart';
import 'package:pope_desktop/core/util/constants.dart';
import 'package:pope_desktop/core/util/extensions.dart';
import 'package:pope_desktop/core/widgets/loading.dart';
import 'package:pope_desktop/features/sayings/ui/bloc/saying_bloc.dart';

class SayingsScreen extends StatefulWidget {
  const SayingsScreen({super.key});

  @override
  State<SayingsScreen> createState() => _SayingsScreenState();
}

class _SayingsScreenState extends State<SayingsScreen> {
  FilePickerResult? image;
  final formKey = GlobalKey<FormState>();
  final sayingController = TextEditingController();
  @override
  void dispose() {
    sayingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<SayingBloc>().add(GetSayingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Text(
                  'اضافة قول',
                  style: context.theme.textTheme.headlineLarge,
                ),
                content: SizedBox(
                  width: 0.3.sw,
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image != null) Image.file(File(image!.files.first.path!)),
                        FormField(
                          validator: (value) {
                            if (image == null) {
                              return 'يجب اختيار صورة';
                            }
                            return null;
                          },
                          builder: (field) => Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  image = await FilePicker.platform.pickFiles(type: FileType.image);
                                  setState(() {});
                                },
                                child: Text(
                                  'اضافة صورة',
                                  style: context.theme.textTheme.headlineMedium?.copyWith(
                                    color: AppPalette.primary,
                                  ),
                                ),
                              ),
                              if (field.hasError)
                                Text(
                                  field.errorText!,
                                  style: context.theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.red,
                                  ),
                                )
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: sayingController,
                          validator: (value) {
                            if (sayingController.text.trim().isEmpty) {
                              return 'يجب اضافة القول';
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<SayingBloc>().add(
                                    AddSayingEvent(text: sayingController.text, filePicker: image!),
                                  );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'اضافة القول',
                            style: context.theme.textTheme.headlineLarge?.copyWith(
                              color: AppPalette.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).then((_) {
            image = null;
            sayingController.clear();
          });
        },
        child: const Icon(
          Icons.comment,
          color: AppPalette.card,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'الاقوال اليومية',
          style: context.theme.textTheme.headlineLarge,
        ),
      ),
      body: BlocBuilder<SayingBloc, SayingState>(
        buildWhen: (previous, current) =>
            current is GetSayingSuccess ||
            current is GetSayingFail ||
            current is GetSayingLoading ||
            current is AddSayingLoading,
        builder: (context, state) {
          if (state is GetSayingSuccess) {
            return GridView.builder(
              itemCount: state.sayings.length,
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
                            // deleteFileDialog(widget.folderContent[index].id);
                          },
                        ),
                      ],
                    );
                  },
                  child: Image.network(
                    Constants.displayFile + state.sayings[index].image,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.not_interested),
                  ),
                );
              },
            );
          } else if (state is GetSayingFail) {
            return Center(
              child: Text(
                state.message,
                style: context.theme.textTheme.headlineLarge,
              ),
            );
          } else {
            return const Loading();
          }
        },
      ),
    );
  }
}
