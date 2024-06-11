class File {
  final String realName;
  final String displayName;
  final bool isDirectory;

  File({required this.displayName, required this.isDirectory, required this.realName});

  factory File.fromJson(Map<String, dynamic> jsonData) {
    return File(
      realName: jsonData['realName'],
      displayName: jsonData['displayName'],
      isDirectory: jsonData['isDirectory'],
    );
  }
}
