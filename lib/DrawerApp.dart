import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/apis/permissionsapi.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/pages/Custom/DrawerContainer.dart';
import 'package:virtual_ranger/pages/Custom/customDrawer.dart';
import 'package:virtual_ranger/pages/business_listings.dart';
import 'package:virtual_ranger/pages/faq_page.dart';
import 'package:virtual_ranger/pages/guide_page.dart';
import 'package:virtual_ranger/pages/kestrel_club_page.dart';
import 'package:virtual_ranger/pages/news_and_deals_page.dart';
import 'package:virtual_ranger/pages/profile_page.dart';
import 'package:virtual_ranger/pages/rule_page.dart';
import 'package:virtual_ranger/pages/settings_page.dart';
import 'package:virtual_ranger/pages/sighting_list.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/readyData.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  late final sharePrefs;

  //pages
  final List<Widget> pages = [
    ProfilePage(),
    NewsAndDealsPage(),
    GuidePage(),
    Kestrel_club_page(),
    SightingslistPage(),
    FAQPage(),
    RulesPage(),
    BusinessListingsPage(),
    SettingsPage(),
  ];

  Future<bool> getConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    super.initState();
    getConnection().then((value) {
      Provider.of<PageProvider>(context, listen: false).setConnection();
    });

    Permissionsapi.askLocationPermission();
    sharePrefs = SharedPreferences.getInstance();
    UserData.getOfflineMode().then((value) => setState(() {
          Provider.of<UserProvider>(context, listen: false).setOffline(value);
          print(value);
        }));
    Provider.of<MapsData>(context, listen: false).getEm();
    Provider.of<MapsData>(context, listen: false).putLegend(context);

    /*getOffline().then((value) async {
      if (value) {
        final pref = await SharedPreferences.getInstance();
        final condition = await pref.getBool('opened1') ?? false;

        !condition
            ? showDialog(
                context: context,
                builder: (context) => Platform.isAndroid
                    ? AlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "You're in offline mode. You can still use the app but you won't be able to see any new sightings or news in real time. You can turn on online mode in the settings."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened1", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToSettings();
                              },
                              child: Text("Go to settings"))
                        ],
                      )
                    : CupertinoAlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "You're in offline mode. You can still use the app but you won't be able to see any new sightings or news in real time. You can turn on online mode in the settings."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened1", true);

                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToSettings();
                                Navigator.pop(context);
                              },
                              child: Text("Go to settings"))
                        ],
                      ),
              )
            : () {};
      } else {
        final pref = await SharedPreferences.getInstance();
        final condition = await pref.getBool('opened') ?? false;

        !condition
            ? showDialog(
                context: context,
                builder: (context) => Platform.isAndroid
                    ? AlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "To use this app in areas without signal please go to settings, download content and toggle on offline mode"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToDownload();
                              },
                              child: Text("Go to settings"))
                        ],
                      )
                    : CupertinoAlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "To use this app in areas without signal please go to settings, download content and toggle on offline mode"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToDownload();
                              },
                              child: Text("Go to settings"))
                        ],
                      ),
              )
            : () {};
      }
    });*/

    Future.delayed(Duration(seconds: 1), () {
      mainPages.removeAt(4);
      mainPages.insert(4, SightingslistPage());
    });
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
        body: Stack(children: [
          //!drawer
          HiddenDrawer(),
          DrawerContainer(),
        ]),
      ),
    );
  }

  Future<bool> getOffline() async {
    SharedPreferences prefs = await sharePrefs;
    return await prefs.getBool('offlineMode') ?? false;
  }
}
