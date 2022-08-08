import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: drawerTextStyle2,
                ),
                ShowUpAnimation(
                  delayStart: Duration(milliseconds: 0),
                  animationDuration: Duration(milliseconds: 500),
                  curve: Curves.easeInCubic,
                  direction: Direction.horizontal,
                  offset: 0.5,
                  child: Text(
                    story.date,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ShowUpAnimation(
                  delayStart: Duration(milliseconds: 600),
                  animationDuration: Duration(seconds: 1),
                  curve: Curves.easeInOutCubic,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Text(
                    story.body.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
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
