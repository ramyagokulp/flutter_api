import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(HiveBlogApp());

class HiveBlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Blog Posts',
      home: HiveBlogHome(),
    );
  }
}

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
      return jsonResponse['result']; // Parse and return the list of posts
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

class PostListItem extends StatelessWidget {
  final dynamic post;

  const PostListItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbnail = post['thumbnail'] ?? 'https://via.placeholder.com/150';
    final author = post['author'] ?? 'Unknown Author';
    final title = post['title'] ?? 'No Title';
    final body = post['body'] ?? 'No Description Available';
    final votes = post['net_votes'] ?? 0;
    final comments = post['children'] ?? 0;
    final createdTime = post['created'] ?? 'Unknown Time';

    // Convert time to relative format
    final createdDateTime = DateTime.tryParse(createdTime);
    final relativeTime = createdDateTime != null
        ? '${DateTime.now().difference(createdDateTime).inHours} hours ago'
        : 'Unknown Time';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: Image.network(
          thumbnail,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By $author • $relativeTime',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              body.substring(0, body.length > 100 ? 100 : body.length),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$votes votes'),
            Text('$comments comments'),
          ],
        ),
      ),
    );
  }
}
