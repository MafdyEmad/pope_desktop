class Rows {
  final int id;
  final String saying;
  final String imagePath;
  final DateTime time;

  Rows({
    required this.id,
    required this.saying,
    required this.imagePath,
    required this.time,
  });

  factory Rows.fromJson(Map<String, dynamic> json) {
    return Rows(
      id: json['id'],
      saying: json['saying'],
      imagePath: json['image_path'],
      time: DateTime.parse(json['time']),
    );
  }
}

class Sayings {
  final List<Rows> rows;

  Sayings({required this.rows});

  factory Sayings.fromJson(Map<String, dynamic> json) {
    var rowsJson = json['rows'] as List;
    List<Rows> rowsList = rowsJson.map((rowJson) => Rows.fromJson(rowJson)).toList();

    return Sayings(rows: rowsList);
  }
}
