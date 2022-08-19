import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/business_listings.dart';
import 'package:virtual_ranger/pages/faq_page.dart';
import 'package:virtual_ranger/pages/guide_page.dart';
import 'package:virtual_ranger/pages/kestrel_club_page.dart';
import 'package:virtual_ranger/pages/news_and_deals_page.dart';
import 'package:virtual_ranger/pages/profile_page.dart';
import 'package:virtual_ranger/pages/rule_page.dart';
import 'package:virtual_ranger/pages/settings_page.dart';
import 'package:virtual_ranger/pages/sighting_list.dart';

import '../models/user.dart';

class PageProvider extends ChangeNotifier {
  var currentPage;

  PageProvider() {
    currentPage = pages[1];
    notifyListeners();
  }

  void switchPage(int num) {
    currentPage = pages[num];
    notifyListeners();
  }

  final List<Widget> pages = [
    ProfilePage(),
    NewsAndDealsPage(),
    const GuidePage(),
    Kestrel_club_page(),
    SightingslistPage(),
    FAQPage(),
    RulesPage(),
    BusinessListingsPage(),
    SettingsPage(),
  ];
}

class UserProvider extends ChangeNotifier {
  User? user;

  void setUser(User x) {
    user = x;
    notifyListeners();
  }
}
