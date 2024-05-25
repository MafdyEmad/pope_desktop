import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/sahre/show_dialog.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/cubit/image_cubit/image_cubit.dart';
import 'package:pope_desktop/models/folder_model.dart';
import 'package:pope_desktop/presentation/widgets/custom_button.dart';
import 'package:pope_desktop/presentation/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final TextEditingController _folderName;
  @override
  void initState() {
    _folderName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _folderName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: BlocBuilder<ImageCubit, ImageState>(
              builder: (context, state) {
                return FutureBuilder<Folder>(
                  future: context.read<ImageCubit>().loadFiles(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        color: AppPalette.foregroundColor,
                        child: GridView.builder(
                          itemCount: snapshot.data!.files.length + 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            if (index == snapshot.data!.files.length) {
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
                                          await context.read<ImageCubit>().createFolder(_folderName.text);
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
                            } else {
                              if (snapshot.data!.files[index].isDirectory) {
                                return Container(
                                  color: AppPalette.backgroundColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_outlined,
                                        size: 80,
                                      ),
                                      Text(
                                        snapshot.data!.files[index].name,
                                        style: AppStyle.bodyLarge(context),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Image.network(
                                    'https://beec-197-59-60-25.ngrok-free.app/explore/${snapshot.data!.files[index].name}');
                              }
                            }
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'حدث خطأ',
                        style: AppStyle.titleLarge(context),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
