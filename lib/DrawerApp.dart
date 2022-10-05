import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'apis/Download.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
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

  @override
  void initState() {
    super.initState();
    Permissionsapi.askLocationPermission();

    UserData.getOfflineMode().then((value) => setState(() {
          Provider.of<UserProvider>(context, listen: false).setOffline(value);
          print(value);
        }));
    Provider.of<MapsData>(context, listen: false).getEm();
    Provider.of<MapsData>(context, listen: false).putLegend(context);
    try {
      DownLoad.updateAlert(context);
    } catch (e) {
      print(e);
    }
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

  //delayed function
  /*Future<void> delayed() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        try {
          await flutterBeacon.initializeScanning;
          await flutterBeacon.initializeAndCheckScanning;
        } on PlatformException catch (e) {
          print(e);
        }

        final regions = <Region>[];

        if (Platform.isIOS) {
          // iOS platform, at least set identifier and proximityUUID for region scanning
          regions.add(Region(
              identifier: 'com.example.myRegion',
              proximityUUID: '83612C8A-EA69-4B62-9087-B3C4BD0F2099'));
        } else {
          // Android platform, it can ranging out of beacon that filter all of Proximity UUID
          regions.add(Region(identifier: 'com.example.myRegion'));
        }

// to start monitoring beacons
        _streamMonitoring =
            flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
          // result contains a region, event type and event state
          print(result);
          InAppNotification.show(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Beacon Detected",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("An event is happening nearby",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blueGrey)),
                          ],
                        ),
                        CupertinoButton(
                            child: Text('view'),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BeaconInfo()));
                            })
                      ]),
                ),
              ),
              context: context);
        });
// to stop monitoring beacons
        _streamMonitoring.cancel();
      },
    );
  }*/
}
