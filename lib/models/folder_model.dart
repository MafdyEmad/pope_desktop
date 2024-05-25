import 'file_model.dart';

class Folder {
  final String path;
  final List<File> files;

  Folder({required this.path, required this.files});

  factory Folder.fromJson(Map<String, dynamic> jsonData) {
    return Folder(
      path: jsonData['path'],
      files: (jsonData['files'] as List).map((fileData) => File.fromJson(fileData)).toList(),
    );
  }
}
