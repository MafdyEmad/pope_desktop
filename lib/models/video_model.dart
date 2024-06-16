class Video {
  int id;
  String link;
  String path;

  Video({
    required this.id,
    required this.link,
    required this.path,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      link: json['link'],
      path: json['path'],
    );
  }
}
