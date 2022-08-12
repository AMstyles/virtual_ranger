import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/pages/Custom/DrawerContainer.dart';
import 'package:virtual_ranger/pages/Custom/customDrawer.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<Anime>(context).isOpen) {
          Provider.of<Anime>(context).closeDrawer;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: Stack(children: const [
          //!drawer
          HiddenDrawer(),
          DrawerContainer(),
        ]),
      ),
    );
  }
}
