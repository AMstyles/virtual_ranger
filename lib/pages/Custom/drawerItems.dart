import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'DrawerItem.dart';

class DrawerItems {
  static final profile =
      DrawerItem(title: 'Profile', icon: Icons.person, num: 0);
  static final dealsAndNews =
      DrawerItem(title: 'Deals & News', icon: Icons.newspaper_rounded, num: 1);

  static final guide =
      DrawerItem(title: 'Guide', icon: Icons.explore_rounded, num: 2);
  static final kestrelClub =
      DrawerItem(title: 'Kestrel Club', icon: Icons.people_alt_rounded, num: 3);
  static final sightingsList = DrawerItem(
      title: 'Sightings List', icon: Icons.location_on_sharp, num: 4);
  static final faq =
      DrawerItem(title: 'FAQ', icon: Icons.question_answer_rounded, num: 5);
  static final rules = DrawerItem(title: 'rules', icon: Icons.rule, num: 6);
  static final businessListings = DrawerItem(
      title: 'Business Listings', icon: Icons.business_rounded, num: 7);
  static final settings =
      DrawerItem(title: 'Settings', icon: Icons.settings, num: 8);

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
