import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/preset_styles.dart';
import 'package:virtual_ranger/pages/Custom/drawerItems.dart';
import 'package:virtual_ranger/pages/splash_screen.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/widgets/drawerWidgets/profile_widg.dart';
import 'AnimeVals.dart';

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
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerProfile(),
          Column(
            children: DrawerItems.all
                .map(
                  (item) => ListTile(
                    style: ListTileStyle.drawer,
                    horizontalTitleGap: 0,
                    contentPadding: const EdgeInsets.only(left: 8),
                    onTap: () {
                      Provider.of<PageProvider>(context, listen: false)
                          .switchPage(item.num);
                      Provider.of<Anime>(context, listen: false).closeDrawer();
                    },
                    leading: Icon(
                      item.icon,
                      color: Colors.white,
                    ),
                    title: Text(
                      item.title,
                      style: drawerTextStyle,
                    ),
                  ),
                )
                .toList(),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.only(left: 8),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SplashScreen()),
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
