import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pope_desktop/bloc/app_cubit/app_cubit.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core-old/share/show_dialog.dart';
import 'package:pope_desktop/core-old/theme/app_palette.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/custom_button.dart';
import 'package:pope_desktop/presentation/widgets/custom_text_form_field.dart';
import 'package:pope_desktop/presentation/widgets/delete_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DisplayVideo extends StatefulWidget {
  final AssetsState state;

  const DisplayVideo({super.key, required this.state});

  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late final YoutubeExplode yt;
  late final TextEditingController _link;
  late final GlobalKey<FormState> _form;

  @override
  void initState() {
    yt = YoutubeExplode();
    _link = TextEditingController();
    _form = GlobalKey<FormState>();

    context.read<AssetsBloc>().add(GetVideosEvent(widget.state.folder.path));

    super.initState();
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  // Future<Playlist?> getVideoDetails() async {
  //   try {
  //     return await yt.playlists.get(widget.state.video[0].link);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.state.video.isNotEmpty ? Alignment.center : Alignment.topRight,
      child: SizedBox(
        width: widget.state.video.length != 1 ? 200.w : 400.w,
        height: widget.state.video.length != 1 ? 200.h : 400.h,
        child: widget.state.video.length != 1
            ? GestureDetector(
                onTap: () {
                  showWindow(
                    context,
                    title: "اضافة فيديو",
                    content: Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "لينك الفيديو",
                                  style: AppStyle.bodyLarge(context),
                                ),
                                CustomTextFormField(
                                  controller: _link,
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
                          Navigator.pop(context);
                          _link.clear();
                        },
                      ),
                      CustomButton(
                        text: 'اضافة',
                        onPressed: () async {
                          try {
                            context
                                .read<AssetsBloc>()
                                .add(AddVideosEvent(widget.state.folder.path, _link.text));
                            Navigator.pop(context);
                            _link.clear();
                            // await yt.videos.get(_link.text).then((video) {
                            //   context
                            //       .read<AssetsBloc>()
                            //       .add(AddVideosEvent(widget.state.folder.path, _link.text));
                            //   _link.clear();
                            // });
                          } catch (e) {
                            context.read<AssetsBloc>().add(const ShowErrorEvent("لينك يوتيوب خطأ"));
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
                          Icons.video_camera_back_outlined,
                          size: 80,
                        ),
                        Text(
                          "اضافة فيديو",
                          style: AppStyle.bodyLarge(context),
                        ),
                      ],
                    ),
                  ),
                ))
            : DeleteButton(
                path: widget.state.video[0].link,
                isDirectory: false,
                onPressed: () {
                  context.read<AssetsBloc>().add(DeleteVideosEvent(widget.state.video[0].id));
                  Navigator.pop(context);
                },
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(widget.state.video[0].link))) {
                        launchUrl(Uri.parse(widget.state.video[0].link));
                      }
                    },
                    child: Text(
                      widget.state.video.first.link,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyMedium(context),
                    ),
                  ),
                ),
              ),
        // : Center(
        //     child: FutureBuilder(
        //       future: getVideoDetails(),
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return
        //         }
        //         if (snapshot.hasError) {
        //           return Center(
        //             child: Text(
        //               "حدث خطأ",
        //               style: AppStyle.bodyLarge(context),
        //             ),
        //           );
        //         }
        //         return const Center(
        //           child: CircularProgressIndicator(
        //             color: AppPalette.primaryColor,
        //           ),
        //         );
        //       },
        //     ),
        //   ),
      ),
    );
  }
}
