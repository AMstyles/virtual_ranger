import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/apis/newsapi.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../models/constants.dart';
import 'businesslistingsapi.dart';
import 'eventapi.dart';

class DownLoad {
  static void downloadAllJson() async {
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
    DownloadImages();
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

  static Future<void> DownloadEvents() async {
    final response = await http.get(Uri.parse(EVENT_URL));
    final data = response.body;
    final dir = await getApplicationDocumentsDirectory();
    final file = await File('${dir.path}/events.json');
    await file.writeAsString(data);
  }

  static void DownloadSpecies() async {
    final response = await http.get(Uri.parse(SPECIES_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/species.json');
    await file.writeAsString(data);
  }

  static void DownloadCategories() async {
    final response = await http.get(Uri.parse(CATEGORY_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/categories.json');
    file.writeAsString(data);
  }

  static void DownloadSubCategories() async {
    final response = await http.get(Uri.parse(SUBCATEGORY_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/sub_categories.json');
    await file.writeAsString(data);
  }

  static void DownloadBusinessListings() async {
    final response = await http.get(Uri.parse(BUSINESS_LISTINGS_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/business_listings.json');
    await file.writeAsString(data);
  }

  static void DownloadFAQ() async {
    final response = await http.get(Uri.parse(FAQ_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/faq.json');
    await file.writeAsString(data);
  }

  void DownloadSightings() async {}

  void DownloadRules() async {}

  static void DownloadImages() async {
    final response = await http.get(Uri.parse(SPECIES_IMAGE_URL));
    final data = response.body;
    var dir = await getApplicationDocumentsDirectory();
    File file = await File('${dir.path}/images.json');
    await file.writeAsString(data);
  }

  static downloadImage(String url, String name) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var imageFile = await File("${dir.path}/images/$name");
    try {
      await dio.download(url, imageFile.path);
    } catch (e) {
      print(e);
    }
  }

  static void downloadAllImages(BuildContext context) async {
    await downloadNewsImages(context);
    await downloadEventsImages(context);
    await downloadCategoryImage(context);
    await downloadSubCategoryImage(context);
    await downloadSpeciesImage(context);
    await downloadBusinessListingsImages(context);
  }

  static downloadNewsImages(BuildContext context) {
    Newsapi.getNewsFromLocal().then((News) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(News.length);
      for (var i = 0; i < News.length; i++) {
        await downloadImage(
            NEWS_IMAGE_URL + News[i].news_image, News[i].news_image);
        print(News[i].news_image);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static downloadEventsImages(BuildContext context) {
    Eventapi.getEventsFromLocal().then((Event) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(Event.length);
      for (var i = 0; i < Event.length; i++) {
        await downloadImage(
            NEWS_IMAGE_URL + Event[i].event_image, Event[i].event_image);
        print(Event[i].event_image);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static downloadBusinessListingsImages(context) {
    BusinessListingsapi.getBusinessListingsFromLocal().then((BL) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(BL.length);
      for (var i = 0; i < BL.length; i++) {
        await downloadImage(
            BUSINESS_LISTINGS_IMAGE_URL + BL[i].logo, BL[i].logo);
        print(BL[i].logo);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static downloadCategoryImage(context) {
    Categoryapi.getCategoriesFromLocal().then((Category) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(Category.length);
      for (var i = 0; i < Category.length; i++) {
        await downloadImage(CATEGORY_IMAGE_URL + Category[i].backgroundImage,
            Category[i].backgroundImage);
        print(Category[i].backgroundImage);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static downloadSubCategoryImage(context) {
    SubCategoryapi.getSubCategoriesFromLocal().then((SubCategory) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(SubCategory.length);
      for (var i = 0; i < SubCategory.length; i++) {
        await downloadImage(
            SUBCATEGORY_IMAGE_URL + SubCategory[i].BackgroundImage,
            SubCategory[i].BackgroundImage);
        print(SubCategory[i].BackgroundImage);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static downloadSpeciesImage(context) {
    Imageapi.getImagesForDownload().then((Species) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(Species.length);
      for (var i = 0; i < Species.length; i++) {
        await downloadImage(
            SPECIES_IMAGE_URL + Species[i].images, Species[i].images);
        print(Species[i].images);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }
}
