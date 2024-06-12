import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pope_desktop/bloc/assets_bloc/assets_bloc.dart';
import 'package:pope_desktop/core/share/app_api.dart';
import 'package:pope_desktop/core/theme/app_palette.dart';
import 'package:pope_desktop/core/theme/app_style.dart';
import 'package:pope_desktop/presentation/widgets/delete_button.dart';
import 'package:pope_desktop/presentation/widgets/sayings.dart';

class DisplaySaying extends StatefulWidget {
  final AssetsState state;

  const DisplaySaying({super.key, required this.state});

  @override
  State<DisplaySaying> createState() => _DisplaySayingState();
}

class _DisplaySayingState extends State<DisplaySaying> {
  @override
  void initState() {
    context.read<AssetsBloc>().add(const GetSayingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.state.saying.rows.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index == widget.state.saying.rows.length) {
          return const Sayings();
        } else {
          final saying = widget.state.saying.rows[index];
          final path = saying.imagePath;

          return DeleteButton(
            path: saying.imagePath,
            onPressed: () {
              context.read<AssetsBloc>().add(
                    DeleteSayingEvent(
                      path: saying.imagePath,
                      id: saying.id,
                    ),
                  );
              Navigator.pop(context);
            },
            isDirectory: false,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  useSafeArea: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppPalette.backgroundColor,
                      ),
                      width: 500,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(
                                '${API.explore}$path',
                                width: 400,
                                height: 400,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                saying.saying,
                                style: AppStyle.bodyMedium(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    '${API.explore}$path',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  Text(
                    saying.saying,
                    style: AppStyle.bodySmall(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.state.saying.rows[index].time.day == DateTime.now().day
                        ? "اليوم"
                        : DateFormat('dd-MM-yyyy', 'ar').format(widget.state.saying.rows[index].time),
                    style: AppStyle.bodySmall(context),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
