class FolderContent {
  final String id;
  final String path;
  final String name;
  final String type;

  FolderContent({required this.id, required this.path, required this.name, required this.type});

  factory FolderContent.fromJson(Map<String, dynamic> json) {
    return FolderContent(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }
}
