import 'package:pope_desktop/features/explorer/data/models/folder_content.dart';

class Folder {
  final String folderId;
  final String folderName;
  final String folderPath;
  final String folderType;
  final List<FolderContent> folderContent;

  Folder(
      {required this.folderId,
      required this.folderName,
      required this.folderPath,
      required this.folderType,
      required this.folderContent});

  factory Folder.fromJson(Map<String, dynamic> json) {
    final content = json['contents'] as List<dynamic>;
    return Folder(
      folderId: json['folderId'] as String,
      folderName: json['folderName'] as String,
      folderPath: json['folderPath'] as String,
      folderType: json['folderType'] as String,
      folderContent: content.map((c) => FolderContent.fromJson(c)).toList(),
    );
  }
}
