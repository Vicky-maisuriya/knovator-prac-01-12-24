import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/post.dart';
import '../utils/constants.dart';

Future<Post> fetchPost(postId) async {
  final response = await http.get(Uri.parse('$postUrl/$postId'));

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception(errorMessagePost);
  }
}