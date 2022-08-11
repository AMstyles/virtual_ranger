import 'package:flutter/material.dart';

class News {


  final String title;
  final String date;

  //dateOfDay alternatively;
  final String body;
  final String imageUrl;

  News(
      {required this.title,
      required this.date,
      required this.body,
      required this.imageUrl});

  static News fromJson(json) {
    return News(
        title: json['title'],
        date: json['news_post_date'],
        body: json['news_text'],
        imageUrl: json['news_image']);
  }
}

List<News> stories = [
  News(
      title: 'Elephant and son_1',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
  News(
      title: 'Elephant and son_2',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
  News(
      title: 'Elephant and son_3',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
  News(
      title: 'Elephant and son_4',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
  News(
      title: 'Elephant and son_5',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
  News(
      title: 'Elephant and son_6',
      date: '08 Aug',
      body: 'bal blah blah and blah',
      imageUrl:
          'https://images.unsplash.com/photo-1592670130429-fa412d400f50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1262&q=80'),
];
