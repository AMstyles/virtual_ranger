import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/apis/permissionsapi.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import '../apis/Download.dart';
import '../services/page_service.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  void initState() {
    super.initState();

    /*UserData.getOfflineMode().then((value) => setState(() {
          isOffline = value;
          print(value);
        }));*/

    print("success 1");

    UserData.getCanGoOffline().then((value) => setState(() {
          canBeOffline = value;
          print(value);
        }));
    print("success 2");

    UserData.getSettingsString('lastSync').then((value) => setState(() {
          lastSync = value;
          print(value);
        }));
    super.initState();
  }

  //bool isOffline = true;
  late bool canBeOffline;
  bool _downloading = false;
  late String lastSync;
  bool isDOwnloadComplete = false;
  int count = 0;

  String date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} @ ${DateTime.now().hour}:${DateTime.now().minute}';

  String getDateString() {
    return '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} @ ${DateTime.now().hour}:${DateTime.now().minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 110,
        color: Colors.grey[200],
        child: SafeArea(
            child: Column(
          children: [
            ListTile(
              title: Text("Last Updated:",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
              trailing:
                  Text(lastSync, style: TextStyle(color: Colors.blueGrey)),
              /*subtitle: isOffline
                  ? Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("update available"),
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                        )
                      ],
                    )
                  : SizedBox(),*/
            )
          ],
        )),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:
              Icon(Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back),
          onPressed: () {
            Provider.of<PageProvider>(context, listen: false).jumpToSettings();
          },
        ),
        title: Text('Download content',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Column(
          children: [
            _downloading
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Please do not exit the app while downloading. This may take a while depending on your internet connection. You will be return to this page when the download is complete. Stay within the App to ensure the download completes successful.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                            height: 100,
                            width: 100,
                            child: Center(
                                child: CircularProgressIndicator.adaptive())),
                      ),
                    ],
                  )
                : SizedBox(),
            isDOwnloadComplete
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                  )
                : SizedBox(),
            ListTile(
              title: const Text(
                'Offline Mode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                setState(() {
                  Provider.of<PageProvider>(context, listen: false)
                      .toggleUniversalOffline();
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
                            Provider.of<PageProvider>(context, listen: false)
                                .setUniversalOffline(newbBol);
                            SharedPreferences.getInstance().then((prefs) {
                              setState(() {
                                UserData.toggleOfflineMode(newbBol);
                                UserData.setSettings('canBeOffline', true);
                              });
                            });
                            showDialog(
                                barrierDismissible: false,
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
                                                  //Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DrawerApp()));
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
                                                  //Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DrawerApp()));
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
            const Divider(),
            _downloading
                ? Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: LinearPercentIndicator(
                            linearGradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.amber,
                                Colors.yellow,
                                Colors.green,
                              ],
                            ),
                            animation: true,
                            width: MediaQuery.of(context).size.width - 20,
                            lineHeight: 20.0,
                            percent: Provider.of<DownloadProvider>(context)
                                .percentage,
                            backgroundColor: Colors.grey.shade200,
                            //progressColor: Colors.blue,
                            center: Text(
                              '${Provider.of<DownloadProvider>(context).imagesDownloaded}/${Provider.of<DownloadProvider>(context).imagesToDownload}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${Provider.of<DownloadProvider>(context).imagesDownloaded}/${Provider.of<DownloadProvider>(context).imagesToDownload}' +
                              ' images downloaded',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(8),
                    child: Text((lastSync != 'never synced')
                        ? 'You have content synced on $lastSync \n '
                        : 'You have never synced content, please sync content to go offline'),
                  ),
            //put some space between the two buttons
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              color: MyColors.primaryColor,
              child: Text((lastSync == 'never synced')
                  ? 'Download & Sync'
                  : 'Check for updates'),
              onPressed: () async {
                Permissionsapi.askStoragePermission();
                (Provider.of<DownloadProvider>(context).imagesDownloaded == 0 ||
                        Provider.of<DownloadProvider>(context)
                                .imagesToDownload ==
                            Provider.of<DownloadProvider>(context)
                                .imagesDownloaded)
                    ? await DownLoad.downloadAllJson().then(
                        (value) {
                          setState(() {
                            _downloading = true;
                            getMetaData();
                          });
                          /* setState(() {
                    getMetaData();
                  });*/
                        },
                      )
                    : () {};
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMetaData() async {
    count++;
    Provider.of<DownloadProvider>(context, listen: false).reset();
    _downloading = true;
    await DownLoad.downloadAllImages(context);

    canBeOffline = true;
    setState(() {
      UserData.setSettings('canBeOffline', true);
      lastSync = getDateString();
    });

    UserData.canGoOffline(true);

    _downloading = false;

    setState(() {
      isDOwnloadComplete = true;
      count = 0;
    });

    UserData.setSettingsString('lastSync', getDateString());
  }

  /*Future<void> off() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isOffline = prefs.getBool('offline') ?? false;
  }*/

  Future<void> start() async {
    setState(() {
      DownLoad.downloadAllJson();
    });
    print("success");
  }

  Future<void> canOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    canBeOffline = prefs.getBool('canOffline') ?? false;
  }

  String makeBool(bool value) {
    if (value == 'true') {
      return 'On';
    } else {
      return 'Off';
    }
  }
}
