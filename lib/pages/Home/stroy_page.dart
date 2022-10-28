import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

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
        addAutomaticKeepAlives: true,
        children: [
          Hero(
            tag: story.title,
            child: (Provider.of<UserProvider>(context).isOffLine ?? false)
                ? !Provider.of<PageProvider>(context).hasConnection
                    ? Image.file(
                        File('${UserData.path}/images/${story.news_image}'),
                      )
                    : CachedNetworkImage(
                        imageUrl: NEWS_IMAGE_URL + story.news_image,
                      )
                : CachedNetworkImage(
                    imageUrl: NEWS_IMAGE_URL + story.news_image,
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
                      color: Colors.blueGrey, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                Text(
                  story.news_text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
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
