import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/pages/BridgePage.dart';
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
  bool isOffline = false;

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
    UserData.getSettings('offlineMode').then((value) {
      setState(() {
        isOffline = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTap: () {
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
            subtitle: const Text('Tap to manually scan for beacons'),
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
          ListTile(
            title: const Text('Automatic updates'),
            subtitle: Text(
                'automatically download & sync new content, when offline is toggled ON'),
            onTap: () {
              setState(() {
                if (isOffline) {
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
            onTap: () {
              setState(() {
                isOffline = !isOffline;
              });
            },
            trailing: Switch.adaptive(
                value: isOffline,
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
                                                Navigator.pop(context);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      );
                              });
                        } else {
                          //TODO: add a check to see if the user has downloaded content
                          isOffline = newbBol;
                          SharedPreferences.getInstance().then((prefs) {
                            setState(() {
                              UserData.toggleOfflineMode(newbBol);
                              UserData.setSettings('canBeOffline', true);
                            });
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Platform.isAndroid
                                    ? AlertDialog(
                                        title: Text('Alert'),
                                        content: Text(
                                            'You have successfully changed your offline mode, this will take effect the next time you open the app'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Ok'))
                                        ],
                                      )
                                    : CupertinoAlertDialog(
                                        title: Text('Offline mode'),
                                        content: Text(
                                            'You have successfully changed your offline mode, this will take effect the next time you open the app'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
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
            textColor: Colors.red,
            title: const Text(
              'Download For Offline',
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
