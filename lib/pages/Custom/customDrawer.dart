import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/preset_styles.dart';
import 'package:virtual_ranger/pages/Custom/drawerItems.dart';
import 'package:virtual_ranger/pages/splash_screen.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import 'package:virtual_ranger/widgets/drawerWidgets/profile_widg.dart';
import 'package:virtual_ranger/widgets/menus.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(0),
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: DrawerProfile()),
          Column(
            children: DrawerItems.all
                .map(
                  (item) => DrawerMenu(item: item),
                )
                .toList(),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.only(left: 8),
            onTap: () async {
              await UserData.logOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false);
            },
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            title: const Text(
              'Logout',
              style: drawerTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
