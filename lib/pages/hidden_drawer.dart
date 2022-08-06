import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:virtual_ranger/models/preset_styles.dart';
import 'package:virtual_ranger/pages/news_and_deals_page.dart';
import 'package:virtual_ranger/pages/settings_page.dart';

class HiddenDrawer extends StatefulWidget {
  HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
        elevationAppBar: 0,
        contentCornerRadius: 0,
        initPositionSelected: 1,
        screens: _pages,
        backgroundColorMenu: Colors.green.shade900);
  }

  void initDrawer() {
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'PROFILE',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'Deals & News',
            selectedStyle: TextStyle()),
        NewsAndDealsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'GUIDE',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'KESTREL CLUB',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'SIGHTING LIST',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'FAQ',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'RULES',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'BUSINESS LISTINGS',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.white,
            baseStyle: drawerTextStyle,
            name: 'Settings',
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
    ];
  }
}
