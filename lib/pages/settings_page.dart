import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/pages/BridgePage.dart';
import 'package:virtual_ranger/pages/prePage.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../services/shared_preferences.dart';
import 'Custom/AnimeVals.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showNotifications = false;
  bool beacons = false;
  bool checkContent = false;
  Color _color = Colors.transparent;
  late Timer _timer;
  //bool isOffline = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserData.getSettings('showNotification').then((value) {
      setState(() {
        showNotifications = value;
      });
    });
    UserData.getSettings('beacons').then((value) {
      setState(() {
        beacons = value;
      });
    });
    UserData.getSettings('checkContent').then((value) {
      setState(() {
        checkContent = value;
      });
    });

    _timer = Timer.periodic(Duration(milliseconds: 1600), (timer) {
      if (!checkContent &&
          Provider.of<PageProvider>(context, listen: false).universalOffline) {
        if (_color == Colors.green.withOpacity(0.5)) {
          setState(() {
            _color = Colors.transparent;
          });
        } else {
          setState(() {
            _color = Colors.green.withOpacity(0.5);
          });
        }
      } else {
        setState(() {
          _color = Colors.transparent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: (),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Beacons Settings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            ),
          ),
          ListTile(
            title: const Text('Show notifications'),
            subtitle: Text('Allows the app to send you notifications '),
            onTap: () async {
              await Permission.notification.request;
              //request notification permission
              if (await Permission.notification.isGranted) {
                //if granted
                setState(() {
                  showNotifications = !showNotifications;
                });
                UserData.setSettings('showNotification', showNotifications);
              } else {
                //if not granted
                setState(() {
                  showNotifications = false;
                });
                UserData.setSettings('showNotification', showNotifications);
              }
              setState(() {
                showNotifications = !showNotifications;
                //set the value in the shared preferences
                UserData.setSettings('showNotification', showNotifications);
              });
            },
            trailing: Switch.adaptive(
                value: showNotifications,
                onChanged: (newbBol) {
                  setState(() {
                    showNotifications = newbBol;
                    //set the value in the shared preferences
                    UserData.setSettings('showNotification', showNotifications);
                  });
                }),
          ),
          const Divider(),
          ListTile(
            title: const Text('Scan for beacons near me'),
            subtitle: const Text('Activate this to scan for beacons near you'),
            onTap: () {
              setState(() {
                beacons = !beacons;
                //set the value in the shared preferences
                UserData.setSettings('beacons', beacons);
              });
            },
            trailing: Switch.adaptive(
                value: beacons,
                onChanged: (newbBol) {
                  setState(() {
                    beacons = newbBol;
                    //set the value in the shared preferences
                    UserData.setSettings('beacons', beacons);
                  });
                }),
          ),
          const Divider(),
          AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 1400),
            color: _color,
            child: ListTile(
              title: const Text('Automatic updates'),
              subtitle: Text(
                  'Automatically download & sync new content when Offline Mode is toggled ON'),
              onTap: () {
                setState(() {
                  if (Provider.of<PageProvider>(context, listen: false)
                      .universalOffline) {
                    checkContent = !checkContent;
                    //set the value in the shared preferences
                    UserData.setSettings('checkContent', checkContent);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Please turn on offline mode first'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Provider.of<PageProvider>(context,
                                            listen: false)
                                        .jumpToDownload();
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                });
              },
              trailing: Switch.adaptive(
                  value: checkContent,
                  onChanged: (newbBol) {
                    setState(() {
                      checkContent = newbBol;
                      //set the value in the shared preferences
                      UserData.setSettings('checkContent', checkContent);
                    });
                  }),
              //trailing: Switch.adaptive(value: value, onChanged: onChanged),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'App Settings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            ),
          ),
          ListTile(
            title: const Text(
              'Offline Mode',
            ),
            subtitle: Text(
                'Use the app without an internet connection. This will download all the content to your device.'),
            onTap: () {
              setState(() {
                Provider.of<PageProvider>(context, listen: false)
                    .jumpToDownload();
              });
            },
            trailing: Switch.adaptive(
                value: Provider.of<PageProvider>(context, listen: false)
                    .universalOffline,
                onChanged: (newbBol) {
                  setState(() {
                    //if the get settings is false in shared preferences, disable the switch
                    UserData.getSettings('canBeOffline').then((value) {
                      setState(() {
                        if (value == false) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Platform.isAndroid
                                    ? AlertDialog(
                                        title: Text('You cannot go offline'),
                                        content: Text(
                                            'You need to download content to go offline'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Provider.of<PageProvider>(
                                                        context,
                                                        listen: false)
                                                    .jumpToDownload();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      )
                                    : CupertinoAlertDialog(
                                        title: Text('You cannot go offline'),
                                        content: Text(
                                            'You need to download content to go offline'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Provider.of<PageProvider>(
                                                        context,
                                                        listen: false)
                                                    .jumpToDownload();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      );
                              });
                        } else {
                          Provider.of<PageProvider>(context, listen: false)
                              .toggleUniversalOffline();
                          SharedPreferences.getInstance().then((prefs) {
                            setState(() {
                              UserData.toggleOfflineMode(newbBol);
                              UserData.setSettings('canBeOffline', true);
                            });
                          });
                          removeAndAddPage();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Platform.isAndroid
                                    ? AlertDialog(
                                        title: Text('Alert'),
                                        content: Text(
                                            'You have successfully changed your offline mode, this will take effect immediately'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PrepPage()),
                                                    (route) => true);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      )
                                    : CupertinoAlertDialog(
                                        title: Text('Offline mode'),
                                        content: Text(
                                            'You have successfully changed your offline mode, this will take effect immediately'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                //navigate and remove
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PrepPage()),
                                                    (route) => true);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      );
                              });
                        }
                      });
                    });
                    //write to shared preferences
                  });
                }),
          ),
          ListTile(
            subtitle: Text('Downloaded content details'),
            textColor: Colors.red,
            title: const Text(
              'Manage Downloads',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return BridgePage();
              })));
            },
            trailing: const Icon(
              Icons.download,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
