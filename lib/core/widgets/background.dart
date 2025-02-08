// import 'package:flutter/material.dart';
// import 'package:pope117/core/config/images_manager.dart';

// class Background extends StatelessWidget {
//   final Widget child;
//   final String backGroundImage;
//   const Background({
//     super.key,
//     required this.child,
//     this.backGroundImage = ImagesManager.emptyBackground,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//             backGroundImage,
//           ),
//           fit: backGroundImage == ImagesManager.emptyBackground ? BoxFit.cover : BoxFit.fill,
//         ),
//       ),
//       child: child,
//     );
//   }
// }
