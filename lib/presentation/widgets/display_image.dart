import 'package:flutter/material.dart';
import 'package:pope_desktop/core/share/app_api.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;
  const DisplayImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '${API.explore}$imagePath',
      fit: BoxFit.fill,
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
    );
  }
}
