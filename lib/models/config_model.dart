import 'package:pope_desktop/core-old/utile/enums.dart'; // Import your enums file

class Config {
  final FilesType type;

  Config({required this.type});

  factory Config.fromJson(Map<String, dynamic> jsonData) {
    switch (jsonData['type']) {
      case 0:
        return Config(type: FilesType.folder);
      case 1:
        return Config(type: FilesType.image);
      case 2:
        return Config(type: FilesType.audio);
      case 3:
        return Config(type: FilesType.video);
      case 4:
        return Config(type: FilesType.pdf);
      default:
        return Config(type: FilesType.folder);
    }
  }
}
