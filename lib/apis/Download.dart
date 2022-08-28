import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/apis/newsapi.dart';
import '../models/constants.dart';
import 'businesslistingsapi.dart';
import 'eventapi.dart';

class DownLoad {
  static void downloadAllJson() {
    DownloadNews();
    print("success 1");
    DownloadEvents();
    print("success 2");
    DownloadBusinessListings();
    print("success 3");
    DownloadFAQ();
    print("success 4");
    DownloadSpecies();
    print("success 5");
    DownloadCategories();
    print("success 6");
    DownloadSubCategories();
    print("success last");
  }

  static void DownloadNews() async {
    getApplicationDocumentsDirectory().then((directory) async {
      final response = await http.get(Uri.parse(NEWS_URL));
      final data = response.body;
      final dir = directory;
      final file = File('${dir.path}/news.json');

      if (!file.existsSync()) {
        file.createSync();
      } else {
        await file.writeAsString(data);
      }
    });
  }

  static void DownloadEvents() async {
    final response = await http.get(Uri.parse(EVENT_URL));
    final data = response.body;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/events.json');
    await file.writeAsString(data);
  }

  static void DownloadSpecies() async {
    final response = await http.get(Uri.parse(SPECIES_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/species.json');
    await file.writeAsString(data);
  }

  static void DownloadCategories() async {
    final response = await http.get(Uri.parse(CATEGORY_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/categories.json');
    file.writeAsString(data);
  }

  static void DownloadSubCategories() async {
    final response = await http.get(Uri.parse(SUBCATEGORY_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/subcategories.json');
    await file.writeAsString(data);
  }

  static void DownloadBusinessListings() async {
    final response = await http.get(Uri.parse(BUSINESS_LISTINGS_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/businesslistings.json');
    await file.writeAsString(data);
  }

  static void DownloadFAQ() async {
    final response = await http.get(Uri.parse(FAQ_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/faq.json');
    await file.writeAsString(data);
  }

  void DownloadSightings() async {}

  void DownloadRules() async {}

  static downloadImage(String url, String name) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var imageFile = File("${dir.path}/images/$name");
    await dio.download(url, imageFile.path);
  }

  static downloadNewsImages() {
    Newsapi.getNewsFromLocal().then((News) {
      for (var i = 0; i < News.length; i++) {
        downloadImage(NEWS_IMAGE_URL + News[i].news_image, News[i].news_image);
      }
    });
  }

  static downloadEventsImages() {
    Eventapi.getEventsFromLocal().then((Event) {
      for (var i = 0; i < Event.length; i++) {
        downloadImage(
            NEWS_IMAGE_URL + Event[i].event_image, Event[i].event_image);
      }
    });
  }

  static downloadBusinessListingsImages() {
    BusinessListingsapi.getBusinessListingsFromLocal().then((BL) {
      for (var i = 0; i < BL.length; i++) {
        downloadImage(BUSINESS_LISTINGS_IMAGE_URL + BL[i].logo, BL[i].logo);
      }
    });
  }

  static downloadCategoryImage() {
    Categoryapi.getCategoriesFromLocal().then((Category) {
      for (var i = 0; i < Category.length; i++) {
        downloadImage(CATEGORY_IMAGE_URL + Category[i].backgroundImage,
            Category[i].backgroundImage);
      }
    });
  }

  static downloadSubCategoryImage() {
    SubCategoryapi.getSubCategoriesFromLocal().then((SubCategory) {
      for (var i = 0; i < SubCategory.length; i++) {
        downloadImage(SUBCATEGORY_IMAGE_URL + SubCategory[i].BackgroundImage,
            SubCategory[i].BackgroundImage);
      }
    });
  }
}
