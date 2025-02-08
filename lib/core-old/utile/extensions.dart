import 'package:pope_desktop/core-old/utile/enums.dart';

extension CleanPathExtension on String {
  String cleanPath() {
    List<String> sections = split('/');
    for (int i = 0; i < sections.length; i++) {
      sections[i] = sections[i].split(r'$%')[0];
    }
    return sections.join('/');
  }
}

extension FilesTypeExtension on FilesType {
  String get getName {
    switch (this) {
      case FilesType.folder:
        return 'مجلد';
      case FilesType.image:
        return 'صورة';
      case FilesType.audio:
        return 'صوت';
      case FilesType.video:
        return 'فيديو';
      case FilesType.pdf:
        return 'PDF';
    }
  }
}
