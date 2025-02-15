class SayingModel {
  final String id;
  final String text;
  final String image;
  final String publishDate;

  SayingModel({required this.id, required this.text, required this.publishDate, required this.image});

  factory SayingModel.fromJson(Map<String, dynamic> map) {
    return SayingModel(
      id: map['_id'] as String,
      image: map['image'] as String,
      text: map['text'] as String,
      publishDate: map['publishDate'] as String,
    );
  }
}
