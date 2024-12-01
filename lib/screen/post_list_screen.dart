import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screen/post_detail_screen.dart';
import '../bloc/post_bloc.dart';
import 'dart:async';
import '../model/post.dart';
import '../utils/constants.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocProvider(
        create: (_) => PostBloc()..fetchPosts(),
        child: const PostListView(),
      ),
    );
  }
}

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.hasError) {
          return Center(child: Text(errorMessage));
        }

        return ListView.builder(
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts[index];
            return PostListItem(post: post);
          },
        );
      },
    );
  }
}

class PostListItem extends StatefulWidget {
  final Post post;

  const PostListItem({Key? key, required this.post}) : super(key: key);

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  late Timer _timer;
  late int _remainingTime;
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = [10, 20, 25][Random().nextInt(3)]; // Random timer
    _timer = Timer.periodic(const Duration(seconds: 1), _countdown);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _countdown(Timer timer) {
    if (_remainingTime > 0) {
      setState(() {
        _remainingTime--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isRead) {
          setState(() {
            _isRead = true;
          });
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: widget.post.id),
          ),
        );
      },
      child: Container(
        color: _isRead ? Colors.white : Colors.yellow[100],
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(widget.post.title)),
            Row(
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                Text('${_remainingTime}s'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}