class Post {
  final int userid;
  final int id;
  final String title;
  final String body;

  Post({required this.userid, required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
