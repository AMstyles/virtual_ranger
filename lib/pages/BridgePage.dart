import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/pages/DownloadPage.dart';
import 'package:virtual_ranger/services/page_service.dart';

import '../apis/Download.dart';

class BridgePage extends StatefulWidget {
  BridgePage({Key? key}) : super(key: key);

  @override
  State<BridgePage> createState() => _BridgePageState();
}

class _BridgePageState extends State<BridgePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await DownLoad.downloadAllJson();
      } catch (e) {
        print(e);
        //show error in an alert dialog
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Error checking content \n" + e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"))
                ],
              );
            });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('downloaded', true);
      Navigator.pop(context);
      Provider.of<PageProvider>(context, listen: false).jumpToDownload();
      /*Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DownloadPage()));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          CircularProgressIndicator.adaptive(),
          Text('Getting ready...'),
        ]),
      ),
    );
  }
}
