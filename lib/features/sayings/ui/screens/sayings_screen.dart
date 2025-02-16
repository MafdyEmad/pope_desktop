import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  final dateController = TextEditingController();
  @override
  void dispose() {
    sayingController.dispose();
    dateController.dispose();
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image != null)
                          Center(
                            child: Image.file(
                              File(image!.files.first.path!),
                              width: 200,
                              height: 200,
                            ),
                          ),
                        Center(
                          child: FormField(
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
                        ),
                        Text(
                          "القول",
                          style: context.theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: sayingController,
                          validator: (value) {
                            if (sayingController.text.trim().isEmpty) {
                              return 'يجب اضافة القول';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "تاريخ النشر",
                          style: context.theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            ).then((value) {
                              if (value != null) {
                                dateController.text = DateFormat('yyyy-MM-dd').format(value);
                                setState(() {});
                              }
                            });
                          },
                          child: TextFormField(
                            style: context.theme.textTheme.bodyMedium,
                            decoration: const InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            enabled: false,
                            controller: dateController,
                            validator: (value) {
                              if (sayingController.text.trim().isEmpty) {
                                return 'يجب اضافة تاريخ النشر';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<SayingBloc>().add(
                                      AddSayingEvent(
                                          text: sayingController.text,
                                          filePicker: image!,
                                          publishDate: dateController.text),
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
            dateController.clear();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<SayingBloc, SayingState>(
          listener: (context, state) {
            if (state is AddSayingSuccess) {
              context.read<SayingBloc>().add(GetSayingEvent());
            }
          },
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
                  childAspectRatio: .9,
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
                              context.read<SayingBloc>().add(DeleteSayingsEvent(id: state.sayings[index].id));
                            },
                          ),
                        ],
                      );
                    },
                    child: Column(
                      children: [
                        Image.network(
                          Constants.displayFile + state.sayings[index].image,
                          width: 200.w,
                          height: 200.h,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.not_interested),
                        ),
                        Text(
                          state.sayings[index].text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.theme.textTheme.headlineLarge,
                        )
                      ],
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
      ),
    );
  }
}
