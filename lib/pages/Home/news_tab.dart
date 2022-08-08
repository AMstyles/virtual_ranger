import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/widgets/NewsWidg.dart';

class NewsTab extends StatefulWidget {
  NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //shrinkWrap: true,
      itemCount: stories.length,
      itemBuilder: ((context, index) {
        return NewsWidg(story: stories[index]);
      }),
    );
  }
}
