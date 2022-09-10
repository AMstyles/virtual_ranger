import 'package:flutter/material.dart';
import '../models/user.dart';

class PageProvider extends ChangeNotifier {
  var currentPage;
  late int currentPageNum;

  PageProvider() {
    currentPageNum = 1;
    notifyListeners();
  }

  void switchPage(int num) {
    //currentPage = pages[num];
    currentPageNum = num;

    notifyListeners();
    setState() {}
    print(currentPageNum);
  }
}

class UserProvider extends ChangeNotifier {
  User? user;
  bool? isOffLine;

  void setUser(User x) {
    user = x;
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
  bool _downloading = false;
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
