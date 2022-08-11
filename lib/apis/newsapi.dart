import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constants.dart';
import '../models/news.dart';

//const String NEWS_URL = 'https://dinokengapp.co.za/news_list/?user_id=0';

class Newsapi {
  static Future<List<News>> getNews() async {
    final response = await http.get(Uri.parse(NEWS_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<News> news = [];
    for (var i = 0; i < finalData.length; i++) {
      news.add(News.fromJson(finalData[i]));
    }
    return news;
  }
}
