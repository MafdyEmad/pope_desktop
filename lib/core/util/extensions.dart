import 'package:flutter/material.dart';

extension AppConfig on BuildContext {
  // get theme
  ThemeData get theme => Theme.of(this);

  // get dimensions
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).width;

  // device type
  bool get isPhone => MediaQuery.of(this).size.width < 600;
}

extension EncodeUrl on String {
  String get GetRout => this.replaceRange(0, 1, '');
  String get encodeLink {
    final List<String> segments = this.split('/');
    final first = segments.first.split(' ').join("%20");
    final last = segments.last.split(' ').join("%20");
    segments
      ..removeAt(0)
      ..removeLast();

    final String combination = segments.join('/');
    final listOfParts = [first, combination, last];
    return listOfParts.join('/').split(' ').join("%20");
  }

  String get removeBaseRoute {
    final pieces = split('\\');
    pieces.removeAt(0);
    return pieces.join('/');
  }

  String get typeName {
    if (this == 'folder') {
      return 'مجلد';
    }
    if (this == 'image') {
      return 'صور';
    }
    if (this == 'audio') {
      return 'صوت';
    }
    if (this == 'video') {
      return 'فيديو';
    }
    if (this == 'PDF') {
      return 'PDF';
    } else {
      return '';
    }
  }
}
