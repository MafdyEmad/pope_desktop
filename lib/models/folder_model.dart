import 'file_model.dart';

class Folder {
  final String path;
  final List<File> files;

  final String directoryType;

  Folder({required this.path, required this.files, required this.directoryType});

  factory Folder.fromJson(Map<String, dynamic> jsonData) {
    return Folder(
      path: jsonData['path'],
      files: (jsonData['files'] as List).map((fileData) => File.fromJson(fileData)).toList(),
      directoryType: jsonData['directoryType'],
    );
  }
}
