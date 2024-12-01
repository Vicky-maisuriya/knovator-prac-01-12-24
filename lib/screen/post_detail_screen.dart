import 'package:flutter/material.dart';
import '../model/post.dart';
import '../request/request_hendler.dart';
import '../utils/constants.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  PostDetailScreen({super.key, required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(errorMessagePost));
          }

          final post = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                Text(post.body),
              ],
            ),
          );
        },
      ),
    );
  }
}