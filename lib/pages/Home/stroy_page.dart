import 'package:flutter/material.dart';
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
              story.Imageurl,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.title,
                style: drawerTextStyle,
              ),
              Text(
                story.date,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                story.body.toString(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
