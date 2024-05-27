import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/bloc/bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/show_dialog.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
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
  @override
  void initState() {
    _folderName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showWindow(
          context,
          title: "اضافة مجلد",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "اسم المجلد",
                style: AppStyle.bodyLarge(context),
              ),
              CustomTextFormField(
                controller: _folderName,
              )
            ],
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
                context.read<AssetsBloc>().add(CreateFolderEvent('${widget.path}/${_folderName.text}'));
                Navigator.pop(context);
                _folderName.clear();
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
                Icons.add,
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
