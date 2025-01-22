

import 'package:flutter/material.dart';

class PostListItem extends StatelessWidget {
  final dynamic post;

  const PostListItem({Key? key, required this.post}) : super(key: key);

  String? extractImageUrl(String body){
    final imageUrlRegex = RegExp(
      r'(https? : \/\/.*\.(?:png|jpg|jpeg|gif))',
      caseSensitive: false,

    );
final match =imageUrlRegex.firstMatch(body);
return match?.group(0);

  }

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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace){
              return Icon(
                Icons.broken_image,
                size: 60,
                color: Colors.grey,
              );
            },
          ),
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
