import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post.dart';
import '../utils/constants.dart';

class PostState {
  final List<Post> posts;
  final bool isLoading;
  final bool hasError;

  PostState({this.posts = const [], this.isLoading = false, this.hasError = false});

  PostState copyWith({List<Post>? posts, bool? isLoading, bool? hasError}) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class PostBloc extends Cubit<PostState> {
  PostBloc() : super(PostState());

  Future<void> fetchPosts() async {

    emit(state.copyWith(isLoading: true));

    try {
      final response = await http.get(Uri.parse(postUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final posts = responseData.map((json) => Post.fromJson(json)).toList();

        /// Save posts in local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(postKey, json.encode(responseData));

        emit(state.copyWith(posts: posts, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, hasError: true));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  /// Load posts from local storage
  Future<void> loadPostsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final postsData = prefs.getString(postKey);

    if (postsData != null) {
      final List<dynamic> data = json.decode(postsData);
      final posts = data.map((json) => Post.fromJson(json)).toList();
      emit(state.copyWith(posts: posts));
    }
  }
}
