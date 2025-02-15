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
      folderId: json['folderId'] ?? '',
      folderName: json['folderName'] ?? '',
      folderPath: json['folderPath'] ?? '',
      folderType: json['folderType'] ?? '',
      folderContent: content.map((c) => FolderContent.fromJson(c)).toList(),
    );
  }
}
