import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/models/news.dart';

import '../../models/preset_styles.dart';

class NewsPage extends StatelessWidget {
  NewsPage({Key? key, required this.story}) : super(key: key);

  News story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: ListView(
        children: [
          Hero(
            tag: story.title,
            child: Image.network(
              NEWS_IMAGE_URL + story.news_image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: drawerTextStyle2,
                ),
                Text(
                  story.news_post_date,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  story.news_text,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
