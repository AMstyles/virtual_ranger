import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/models/user.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

import '../apis/Download.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getMetaData();
    UserData.getOfflineMode().then((value) => setState(() {
          isOffline = value;
          print(value);
        }));

    print("success 1");

    UserData.getCanGoOffline().then((value) => setState(() {
          canBeOffline = value;
          print(value);
        }));
    print("success 2");
    super.initState();
  }

  int _imagesToDownload = 0;
  int _imagesDownloaded = 0;
  late bool isOffline;
  late bool canBeOffline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download content'),
      ),
      body: Center(
        child: Column(
          children: [
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
                      isOffline = newbBol;
                      //write to shared preferences
                      SharedPreferences.getInstance().then((prefs) {
                        setState(() {
                          UserData.toggleOfflineMode(newbBol);
                        });
                      });
                    });
                  }),
            ),
            const Divider(),
            Text(
              '$_imagesDownloaded/$_imagesToDownload' + ' images downloaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            ElevatedButton(
              child: const Text('Download'),
              onPressed: () {
                getMetaData();
              },
            ),
          ],
        ),
      ),
    );
  }

  void getMetaData() async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Getting metadata'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text('please wait...'),
              ],
            ),
          );
        }));

    setState(() {
      DownLoad.downloadAllJson();
    });
    //getApplicationDocumentsDirectory().then((directory) {
    //Directory dir = directory;
    //File file = File('${dir.path}/news.json');
    //final contents = file.readAsStringSync();
    //print(contents);
    // });
    Navigator.pop(context);
  }

  Future<void> off() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isOffline = prefs.getBool('offline') ?? false;
  }

  Future<void> canOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    canBeOffline = prefs.getBool('canOffline') ?? false;
  }
}
