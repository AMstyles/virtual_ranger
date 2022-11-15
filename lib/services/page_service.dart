import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/DownloadPage.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
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

void removeAndAddPage() {
  removePage();
  addPage();
}

/*void restartSightingsPage() {
  mainPages.removeAt(4);
  mainPages.insert(4, SightingslistPage());
}*/

void removePage() {
  mainPages.removeAt(9);
}

void addPage() {
  mainPages.add(DownloadPage());
}

class PageProvider extends ChangeNotifier {
  var currentPage;
  late int currentPageNum;
  late bool universalOffline;
  late bool hasConnection;

  PageProvider() {
    currentPageNum = 1;
    setset();
    notifyListeners();
  }

  void setset() async {
    universalOffline = await UserData.getSettings('offlineMode');
    notifyListeners();
  }

  void toggleUniversalOffline() {
    universalOffline = !universalOffline;
    notifyListeners();
  }

  void setUniversalOffline(bool value) {
    universalOffline = value;
    notifyListeners();
  }

  void switchPage(int num) {
    currentPageNum = num;
    notifyListeners();
    print(currentPageNum);
  }

  void jumpToSettings() {
    switchPage(8);
    notifyListeners();
  }

  void jumpToDownload() {
    switchPage(9);
    notifyListeners();
  }

  //constructor
  void setConnection() async {
    hasConnection = await InternetConnectionChecker().hasConnection;

    notifyListeners();
  }

  Future<bool> canDoOnline(context) async {
    bool ans = await InternetConnectionChecker().hasConnection;
    if (ans) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(
              width: 10,
            ),
            Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }

  void ConnectionStream(context) {
    //stream to check for connection
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          hasConnection = true;
          //show snack bar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Connected',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            duration: Duration(seconds: 5),
          ));
          notifyListeners();
          break;
        case InternetConnectionStatus.disconnected:
          hasConnection = false;
          //show snack bar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            action: !(Provider.of<UserProvider>(context).isOffLine)!
                ? SnackBarAction(
                    textColor: Colors.white,
                    label: 'Go Offline',
                    onPressed: () {
                      Provider.of<PageProvider>(context, listen: false)
                          .jumpToDownload();
                    },
                  )
                : null,
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'No Connection',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            duration: Duration(seconds: 15),
          ));
          notifyListeners();
          break;
      }
    });
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
  List<int> updates = [];

  void getPercentage() {
    if (imagesDownloaded / imagesToDownload < 1) {
      percentage = imagesDownloaded / imagesToDownload;
    } else {
      percentage = 1;
    }
    notifyListeners();
  }

  void incrementImagesDownloaded() {
    if (imagesDownloaded > imagesDownloaded) {
      imagesDownloaded = imagesToDownload;
    } else {
      imagesDownloaded++;
    }
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
