import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/bloc/app_cubit/app_cubit.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/show_dialog.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/custom_button.dart';
import 'package:pope_desktop/presentation/widgets/custom_text_form_field.dart';

class Sayings extends StatefulWidget {
  const Sayings({super.key});

  @override
  State<Sayings> createState() => _SayingsState();
}

class _SayingsState extends State<Sayings> {
  late final TextEditingController _saying;
  late final GlobalKey<FormState> _form;
  FilePickerResult? _file;
  @override
  void initState() {
    _saying = TextEditingController();
    _form = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _saying.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showWindow(
          context,
          title: "اضافة قول",
          content: Form(
            key: _form,
            child: SingleChildScrollView(
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_file != null)
                        Center(
                          child: Image.file(
                            File(_file!.files.first.path.toString()),
                            width: 100,
                            height: 100,
                          ),
                        )
                      else
                        Container(),
                      SizedBox(height: 20.h),
                      Center(
                        child: SizedBox(
                          width: 200.w,
                          child: CustomButton(
                            text: 'اضافة صوره',
                            onPressed: () async {
                              final RegExp image = RegExp(r'(jpeg|jpg|gif|png)$', caseSensitive: true);
                              await FilePicker.platform.pickFiles().then((value) {
                                if (value != null) {
                                  if (image.hasMatch(value.files.first.extension.toString())) {
                                    _file = value;
                                    context.read<AppCubit>().addImage();
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        "القول",
                        style: AppStyle.bodyLarge(context),
                      ),
                      CustomTextFormField(
                        controller: _saying,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            CustomButton(
              text: 'الغاء',
              isPrimary: false,
              onPressed: () {
                _saying.clear();
                _file = null;
                Navigator.pop(context);
              },
            ),
            CustomButton(
              text: 'اضافة',
              onPressed: () async {
                if (_form.currentState!.validate() && _file != null) {
                  context.read<AssetsBloc>().add(AddSayingEvent(file: _file!, saying: _saying.text));
                  Navigator.pop(context);
                  _saying.clear();
                } else {}
              },
            ),
          ],
        );
      },
      child: DottedBorder(
        strokeCap: StrokeCap.square,
        strokeWidth: 2,
        dashPattern: const [1, 10],
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_copy_outlined,
                size: 80,
              ),
              Text(
                "اضافه مجلد",
                style: AppStyle.bodyLarge(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//context.read<AssetsBloc>().add(UploadAssetsEvent(path, type, fileLength));