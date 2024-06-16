class File {
  final String name;
  final bool isDirectory;

  File({
    required this.name,
    required this.isDirectory,
  });

  factory File.fromJson(Map<String, dynamic> jsonData) {
    return File(
      name: jsonData['name'],
      isDirectory: jsonData['isDirectory'],
    );
  }
}
