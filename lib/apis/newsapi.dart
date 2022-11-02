import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/constants.dart';
import '../models/news.dart';

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

  static Future<List<News>> getNewsFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = await File('${dir.path}/news.json');
    String data = await file.readAsStringSync();
    try {
      final pre_data = jsonDecode(data);
      final List<dynamic> finalData = pre_data['data'];
      List<News> news = [];
      for (var i = 0; i < finalData.length; i++) {
        news.add(News.fromJson(finalData[i]));
      }
      return news;
    } catch (e) {
      print('The error is $e');
    }
    final pre_data = jsonDecode(data);
    final List<dynamic> finalData = pre_data['data'];
    List<News> news = [];
    for (var i = 0; i < finalData.length; i++) {
      news.add(News.fromJson(finalData[i]));
    }
    return news;
  }
}
