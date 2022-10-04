import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'BeaconInfo.dart';

class BeaconPage extends StatefulWidget {
  BeaconPage({Key? key}) : super(key: key);

  @override
  State<BeaconPage> createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  void initBeacon() async {
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
      print(e.code);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBeacon();
    scanner1();
    scanner2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beacon Page"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => InAppNotification.show(
              duration: Duration(seconds: 8),
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
              context: context),
          child: AvatarGlow(
            child: Icon(Icons.phone_iphone_rounded, size: 60),
            endRadius: 200,
            glowColor: Colors.green,
            showTwoGlows: true,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: GestureDetector(
          onTap: () => InAppNotification.show(
              child: Card(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Text("Hello"),
                  ),
                ),
              ),
              context: context),
          child: Container(
            height: 50,
            child: Center(child: Text('Scaniing for Beacons')),
          ),
        ),
      ),
    );
  }

  void scanner1() async {
    print('running scanner');
    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(
        Region(
            identifier: 'denokeng',
            proximityUUID: 'e9b74c2f-8977-4788-bbb4-7ccd9cf19aad'),
      );
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

// to start ranging beacons
    var _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      // result contains a region and list of beacons found
      // list can be empty if no matching beacons were found in range
      print("scanner one catched");
      print(result);
    });

// to stop ranging beacons
    _streamRanging.cancel();
  }

  void scanner2() async {
    print('running scanner 2');
    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'denokeng Airlocate',
          proximityUUID: 'e9b74c2f-8977-4788-bbb4-7ccd9cf19aad'));
    } else {
      // Android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

// to start monitoring beacons
    var _streamMonitoring =
        flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
      // result contains a region, event type and event state

      final major = result.region.major;
      final minor = result.region.minor;
      final proximityUUID = result.region.proximityUUID;
      final identifier = result.region.identifier;

      print('major: $major, minor: $minor, proximityUUID: $proximityUUID');
    });

// to stop monitoring beacons
    _streamMonitoring.cancel();
  }
}
