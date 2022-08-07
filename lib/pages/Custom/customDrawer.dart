import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/preset_styles.dart';
import 'package:virtual_ranger/pages/Custom/drawerItems.dart';
import 'package:virtual_ranger/widgets/drawerWidgets/profile_widg.dart';

import '../news_and_deals_page.dart';

class HiddenDrawer extends StatefulWidget {
  HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerProfile(),
          Column(
            children: DrawerItems.all
                .map(
                  (item) => ListTile(
                    onTap: () {},
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
        ],
      ),
    );
  }
}
