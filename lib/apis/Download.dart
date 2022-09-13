import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/apis/newsapi.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../models/constants.dart';
import '../pages/Custom/AnimeVals.dart';
import '../services/shared_preferences.dart';
import 'businesslistingsapi.dart';
import 'eventapi.dart';

class DownLoad {
  static Future<void> downloadAllJson() async {
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
    final response = await http.get(Uri.parse(NEWS_URL));
    final data = response.body;
    final file = File('${UserData.path}/news.json');

    if (!file.existsSync()) {
      file.createSync(recursive: true); // create file if not exists

    } else {
      file.writeAsStringSync(data);
    }
  }

  static Future<void> DownloadEvents() async {
    final response = await http.get(Uri.parse(EVENT_URL));
    final data = response.body;
    final file = await File('${UserData.path}/events.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static void DownloadSpecies() async {
    final response = await http.get(Uri.parse(SPECIES_URL));
    final data = response.body;
    File file = await File('${UserData.path}/species.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static void DownloadCategories() async {
    final response = await http.get(Uri.parse(CATEGORY_URL));
    final data = response.body;
    File file = await File('${UserData.path}/categories.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static void DownloadSubCategories() async {
    final response = await http.get(Uri.parse(SUBCATEGORY_URL));
    final data = response.body;
    File file = await File('${UserData.path}/sub_categories.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static void DownloadBusinessListings() async {
    final response = await http.get(Uri.parse(BUSINESS_LISTINGS_URL));
    final data = response.body;
    File file = await File('${UserData.path}/business_listings.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static void DownloadFAQ() async {
    final response = await http.get(Uri.parse(FAQ_URL));
    final data = response.body;
    File file = await File('${UserData.path}/faq.json');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  void DownloadSightings() async {}

  static void DownloadImages() async {
    final response = await http.get(Uri.parse(SPECIES_IMAGE_URL));
    final data = response.body;
    File file = await File('${UserData.path}/images.json');
    print("Download image data success");
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else {
      file.writeAsStringSync(data);
    }
  }

  static downloadImage(String url, String name) async {
    Dio dio = Dio();
    File imageFile = await File("${UserData.path}/images/$name");
    try {
      await dio.download(url, imageFile.path);
    } catch (e) {
      print(e);
    }
    if (!imageFile.existsSync()) {
      imageFile.createSync(recursive: true);
    }
  }

  static Future<void> downloadAllImages(BuildContext context) async {
    await downloadNewsImages(context);
    await downloadEventsImages(context);
    await downloadCategoryImage(context);
    await downloadSubCategoryImage(context);
    await downloadSpeciesImage(context);
    await downloadBusinessListingsImages(context);
    showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
                title: Text("Download Complete"),
                content: Text(
                    "All images have been downloaded, you can toggle the offline mode in the settings page"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<PageProvider>(context, listen: false)
                            .jumpToDownload();
                        if (Provider.of<Anime>(context).isOpen) {
                          Provider.of<Anime>(context, listen: false)
                              .closeDrawer();
                        }
                      },
                      child: Text("toggle now"))
                ],
              )
            : CupertinoAlertDialog(
                title: Text("Download Complete"),
                content: Text(
                    "All images have been downloaded, you can toggle the offline mode in the settings page"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Provider.of<PageProvider>(context, listen: false)
                            .jumpToDownload();
                        if (Provider.of<Anime>(context).isOpen) {
                          Provider.of<Anime>(context, listen: false)
                              .closeDrawer();
                        }
                      },
                      child: Text("toggle now"))
                ],
              ));
  }

  static downloadNewsImages(BuildContext context) {
    Newsapi.getNewsFromLocal().then((News) async {
      print(News);
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
        try {
          await downloadImage(
              BUSINESS_LISTINGS_IMAGE_URL + BL[i].logo, BL[i].logo);
        } catch (e) {
          print(e);
          await downloadImage(
              BUSINESS_LISTINGS_IMAGE_URL + BL[i].logo, BL[i].logo);
        }

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

  static downloadSpeciesImage(context) async {
    await Imageapi.getImagesForDownload().then((Species) async {
      Provider.of<DownloadProvider>(context, listen: false)
          .setImagesToDownload(Species.length);
      for (var i = 0; i < Species.length; i++) {
        await getIm(BASE_IMAGE_URL + Species[i].images);
        Provider.of<DownloadProvider>(context, listen: false)
            .incrementImagesDownloaded();
      }
    });
  }

  static Future<void> getIm(String url) async {
    Dio dio = await Dio();
    String filePath = UserData.path + "/" + url.split('/').last;
    print(filePath);
    try {
      await dio.download(url, filePath);
    } catch (e) {
      print(e);
    }
  }
}
