import 'package:flutter/material.dart';

import 'DrawerItem.dart';

class DrawerItems {
  static final dealsAndNews =
      DrawerItem(title: 'Deals & News', icon: Icons.settings);
  static final settings = DrawerItem(title: 'Setiings', icon: Icons.settings);

  static final List<DrawerItem> all = [
    dealsAndNews,
    settings,
  ];
}
