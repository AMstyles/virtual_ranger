import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/apis/Download.dart';
import 'package:virtual_ranger/pages/splash_screen.dart';
import '../DrawerApp.dart';
import '../models/constants.dart';
import '../models/user.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class PrepPage extends StatefulWidget {
  const PrepPage({Key? key}) : super(key: key);

  @override
  State<PrepPage> createState() => _PrepPageState();
}

class _PrepPageState extends State<PrepPage> {
  late final sharePrefs;
  String _msg = 'Preparing for your adventure...';
  String date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} @ ${DateTime.now().hour}:${DateTime.now().minute}';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharePrefs = SharedPreferences.getInstance();
    startUser();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _msg = 'Downloading & Syching Content...';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingBouncingGrid.circle(
              size: 100,
              backgroundColor: MyColors.primaryColor,
              duration: Duration(seconds: 1),
              inverted: true,
            ),
            Text(
              'Preparing for your adventure...',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startUser() async {
    if (await UserData.getSettings('checkContent') &&
        await UserData.getOfflineMode()) {
      await DownLoad.downloadAllJson();
      await DownLoad.downloadAllImages(context);
      UserData.setSettingsString('lastSync', date);
    }
    print(await UserData.isLoggedIn());
    if (await UserData.isLoggedIn() == true) {
      print(await UserData.isLoggedIn());

      Future<User> user = UserData.getUser();
      Provider.of<UserProvider>(context, listen: false).setUser(await user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DrawerApp()));
      showDialogs();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }

  void showDialogs() async {
    getOffline().then((value) async {
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
    });
  }

  Future<bool> getOffline() async {
    SharedPreferences prefs = await sharePrefs;
    return await prefs.getBool('offlineMode') ?? false;
  }
}
