import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/pages/Custom/DrawerContainer.dart';
import 'package:virtual_ranger/pages/Custom/customDrawer.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  void askPermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    askPermission();

    UserData.getOfflineMode().then((value) => setState(() {
          Provider.of<UserProvider>(context, listen: false).setOffline(value);
          print(value);
        }));
  }

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
