import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'DrawerItem.dart';

class DrawerItems {
  static final profile =
      DrawerItem(title: 'Profile', image: 'lib/icons/icons8_male_user_72.png', num: 0);
  static final dealsAndNews = DrawerItem(
      title: 'Deals & News', image: 'lib/icons/icons8_bull_72.png', num: 1);

  static final guide =
      DrawerItem(title: 'Guide', image: 'lib/icons/icons8_giraffe_72.png', num: 2);
  static final kestrelClub = DrawerItem(
      title: 'Kestrel Club', image: 'lib/icons/iconFalcon.png', num: 3);
  static final sightingsList = DrawerItem(
      title: 'Sightings List', image: 'lib/icons/icons8_eye_72.png', num: 4);
  static final faq =
      DrawerItem(title: 'FAQ', image: 'lib/icons/icons8_faq_72.png', num: 5);
  static final rules =
      DrawerItem(title: 'Rules', image: 'lib/icons/icons8_elephant_72.png', num: 6);
  static final businessListings = DrawerItem(
      title: 'Business Listings', image: 'lib/icons/icons8_year_of_snake_72.png', num: 7);
  static final settings = DrawerItem(
      title: 'Settings', image: 'lib/icons/icon_settings.png', num: 8);

  static final List<DrawerItem> all = [
    profile,
    dealsAndNews,
    guide,
    kestrelClub,
    sightingsList,
    faq,
    rules,
    businessListings,
    settings,
  ];
}
