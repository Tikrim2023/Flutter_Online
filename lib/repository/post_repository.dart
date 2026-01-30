import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_api_project/model/post.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      debugPrint(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception("Failed to create post");
    }

    // Edit/update class
    Future<void> updatePost(Post post) async {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update post");
      }
    }
    // Void here means that  we don't expect any data back. This code only tells us whether  the post was deleted or not.
    Future<void> deletePost(int id) async {
      final response = await http.delete(
        // Gives the ID of the post i want to delete
        Uri.parse('$baseUrl/posts/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete post");
      }
    }
  }
}
