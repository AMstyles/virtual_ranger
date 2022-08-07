import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'DrawerItem.dart';

class DrawerItems {
  static final profile = DrawerItem(title: 'Profile', icon: Icons.person);
  static final dealsAndNews =
      DrawerItem(title: 'Deals & News', icon: Icons.newspaper_rounded);

  static final guide = DrawerItem(title: 'Guide', icon: Icons.explore_rounded);
  static final kestrelClub =
      DrawerItem(title: 'Kestrel Club', icon: Icons.people_alt_rounded);
  static final sightingsList =
      DrawerItem(title: 'Sightings List', icon: Icons.location_on_sharp);
  static final faq =
      DrawerItem(title: 'FAQ', icon: Icons.question_answer_rounded);
  static final rules = DrawerItem(title: 'rules', icon: Icons.rule);
  static final businessListings =
      DrawerItem(title: 'Business Listings', icon: Icons.business_rounded);
  static final settings = DrawerItem(title: 'Settings', icon: Icons.settings);
  static final logOut =
      DrawerItem(title: 'Log Out', icon: Icons.logout_rounded);

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
    logOut
  ];
}
