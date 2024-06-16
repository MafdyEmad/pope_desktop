import 'package:pope_desktop/models/config_model.dart';

import 'file_model.dart';

class Folder {
  final String path;
  final List<File> files;
  final Config config;

  Folder({required this.path, required this.files, required this.config});

  factory Folder.fromJson(Map<String, dynamic> jsonData) {
    return Folder(
      path: jsonData['path'],
      config: Config.fromJson(jsonData['config']),
      files: (jsonData['files'] as List).map((fileData) => File.fromJson(fileData)).toList(),
    );
  }
}
