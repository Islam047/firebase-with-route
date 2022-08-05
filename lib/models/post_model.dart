class Post {
  late int id;
  late String userId;
  late String title;
  late String content;
  String? image;

  Post(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      this.image});

  Post.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    title = json["title"];
    content = json["content"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'image': image,
    };
    return map;
  }
}
