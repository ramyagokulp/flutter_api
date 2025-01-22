import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_intrvw/post_list.dart';

class HiveBlogHome extends StatefulWidget {
  @override
  _HiveBlogHomeState createState() => _HiveBlogHomeState();
}

class _HiveBlogHomeState extends State<HiveBlogHome> {
  late Future<List<dynamic>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  // Function to fetch posts from the API 
  Future<List<dynamic>> fetchPosts() async {
    final response = await http.post(
      Uri.parse('https://api.hive.blog/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "id": 1,
        "jsonrpc": "2.0",
        "method": "bridge.get_ranked_posts",
        "params": {"sort": "trending", "tag": "", "observer": "hive.blog"}
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
     final posts = jsonResponse['result'];
     for(var post in posts){
      print(post['thumbnail']);// Print each thumbnail URL
     } 

     return posts;
     // Parse and return the list of posts

    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Blog Posts'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostListItem(post: post);
              },
            );
          }
        },
      ),
    );
  }
}