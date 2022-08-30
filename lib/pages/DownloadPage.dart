import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  late bool isOffline;
  late bool canBeOffline;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download content'),
      ),
      body: Center(
        child: Column(
          children: [
            _downloading
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                        height: 100,
                        width: 100,
                        child: Center(
                            child: CircularProgressIndicator.adaptive())),
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
            ElevatedButton(
              child: const Text('Downnload to device'),
              onPressed: () {
                setState(() {
                  _downloading = true;
                  getMetaData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void getMetaData() {
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
      DownLoad.downloadAllJson();
      DownLoad.downloadAllJson();
    });

    Navigator.pop(context);

    setState(() {
      _downloading = true;
      DownLoad.downloadAllImages(context);
      _downloading = false;
      canBeOffline = true;
      UserData.canGoOffline(true);
    });
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
