import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/app_cubit/app_cubit.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core-old/share/show_dialog.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';
import 'package:pope_desktop/core-old/utile/enums.dart';
import 'package:pope_desktop/presentation/widgets/custom_button.dart';
import 'package:pope_desktop/presentation/widgets/custom_text_form_field.dart';

class CreateFolder extends StatefulWidget {
  final String path;
  const CreateFolder({super.key, required this.path});

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  late final TextEditingController _folderName;
  late final GlobalKey<FormState> _form;
  FilesType fileType = FilesType.folder;
  @override
  void initState() {
    _folderName = TextEditingController();
    _form = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _folderName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showWindow(
          context,
          title: "اضافة مجلد",
          content: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "اسم المجلد",
                  style: AppStyle.bodyLarge(context),
                ),
                CustomTextFormField(
                  controller: _folderName,
                ),
                const SizedBox(height: 10),
                Text(
                  "نوع المجلد",
                  style: AppStyle.bodyLarge(context),
                ),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              RadioListTile(
                                value: FilesType.folder,
                                groupValue: fileType,
                                onChanged: (value) {
                                  fileType = value as FilesType;
                                  context.read<AppCubit>().changeRadioButton();
                                },
                                title: Text(
                                  "مجلد",
                                  style: AppStyle.bodyLarge(context),
                                ),
                              ),
                              RadioListTile(
                                value: FilesType.image,
                                groupValue: fileType,
                                onChanged: (value) {
                                  fileType = value as FilesType;
                                  context.read<AppCubit>().changeRadioButton();
                                },
                                title: Text(
                                  "صور",
                                  style: AppStyle.bodyLarge(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              RadioListTile(
                                value: FilesType.video,
                                groupValue: fileType,
                                onChanged: (value) {
                                  fileType = value as FilesType;
                                  context.read<AppCubit>().changeRadioButton();
                                },
                                title: Text(
                                  "فيديو",
                                  style: AppStyle.bodyLarge(context),
                                ),
                              ),
                              RadioListTile(
                                value: FilesType.audio,
                                groupValue: fileType,
                                onChanged: (value) {
                                  fileType = value as FilesType;
                                  context.read<AppCubit>().changeRadioButton();
                                },
                                title: Text(
                                  "صوت",
                                  style: AppStyle.bodyLarge(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: FilesType.pdf,
                            groupValue: fileType,
                            onChanged: (value) {
                              fileType = value!;
                              context.read<AppCubit>().changeRadioButton();
                            },
                            title: Text(
                              "pdf",
                              style: AppStyle.bodyLarge(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(
              text: 'الغاء',
              isPrimary: false,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CustomButton(
              text: 'اضافة',
              onPressed: () async {
                if (_form.currentState!.validate()) {
                  String fullPath = "${widget.path}/${_folderName.text}";
                  context.read<AssetsBloc>().add(CreateFolderEvent(fullPath, fileType));
                  Navigator.pop(context);
                  _folderName.clear();
                }
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
