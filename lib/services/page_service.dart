import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/DownloadPage.dart';
import '../models/user.dart';
import '../pages/business_listings.dart';
import '../pages/faq_page.dart';
import '../pages/guide_page.dart';
import '../pages/kestrel_club_page.dart';
import '../pages/news_and_deals_page.dart';
import '../pages/profile_page.dart';
import '../pages/rule_page.dart';
import '../pages/settings_page.dart';
import '../pages/sighting_list.dart';

List<Widget> mainPages = [
  ProfilePage(),
  NewsAndDealsPage(),
  GuidePage(),
  Kestrel_club_page(),
  SightingslistPage(),
  FAQPage(),
  RulesPage(),
  BusinessListingsPage(),
  SettingsPage(),
  DownloadPage()
];

class PageProvider extends ChangeNotifier {
  var currentPage;
  late int currentPageNum;

  PageProvider() {
    currentPageNum = 1;
    notifyListeners();
  }

  void switchPage(int num) {
    currentPageNum = num;
    notifyListeners();
    print(currentPageNum);
  }

  void jumpToSettings() {
    switchPage(8);
  }

  void jumpToDownload() {
    switchPage(9);
  }
}

class UserProvider extends ChangeNotifier {
  User? user;
  bool? isOffLine;

  void setUser(User x) {
    this.user = x;
    notifyListeners();
  }

  void incrementKestel_points() {
    user!.kestle_points++;
    notifyListeners();
  }

  void setOffline(bool x) {
    isOffLine = x;
    notifyListeners();
  }
}

class DownloadProvider extends ChangeNotifier {
  int imagesToDownload = 0;
  int imagesDownloaded = 0;
  double percentage = 0.0;
  bool isOffline = false;

  void getPercentage() {
    if (imagesDownloaded / imagesToDownload < 1) {
      percentage = imagesDownloaded / imagesToDownload;
    } else {
      percentage = 1;
    }
    notifyListeners();
  }

  void incrementImagesDownloaded() {
    imagesDownloaded++;
    getPercentage();
    notifyListeners();
  }

  void setImagesToDownload(int x) {
    imagesToDownload += x;
    getPercentage();
    notifyListeners();
  }

  DownloadProvider() {
    notifyListeners();
  }

  void setOffline(bool x) {
    isOffline = x;
    notifyListeners();
  }

  void reset() {
    imagesToDownload = 0;
    imagesDownloaded = 0;
    percentage = 0.0;
    notifyListeners();
  }
}
