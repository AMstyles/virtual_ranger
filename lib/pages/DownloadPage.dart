import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import '../apis/Download.dart';
import '../services/page_service.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    UserData.getOfflineMode().then((value) {
      setState(() {
        isOffline = value;
        print(value);
      });
    });

    print("success 1");

    UserData.getCanGoOffline().then((value) => setState(() {
          canBeOffline = value;
          print(value);
        }));
    print("success 2");
    super.initState();
  }

  late bool isOffline;
  late bool canBeOffline;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Please do not exit the app while downloading, this may take a while depending on your internet connection, you will be notified when the download is complete. Stay within the App to ensure the download is successful.',
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
            const Divider(),
            Padding(
              padding: EdgeInsets.all(10),
              child: LinearPercentIndicator(
                linearGradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.amber,
                    Colors.yellow,
                    Colors.greenAccent,
                    Colors.green,
                  ],
                ),
                animation: true,
                width: MediaQuery.of(context).size.width - 20,
                lineHeight: 20.0,
                percent: Provider.of<DownloadProvider>(context).percentage,
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

            //put some space between the two buttons
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              color: MyColors.primaryColor,
              child: const Text('Downnload / Update content'),
              onPressed: () {
                setState(() {
                  _downloading = true;
                  getMetaData();
                });
                setState(() {
                  getMetaData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMetaData() async {
    _downloading = true;
    await DownLoad.downloadAllImages(context);

    canBeOffline = true;
    setState(() {
      UserData.setSettings('canBeOffline', true);
    });

    UserData.canGoOffline(true);
    _downloading = false;
  }

  Future<void> off() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isOffline = prefs.getBool('offline') ?? false;
  }

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
