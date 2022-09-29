import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconPage extends StatefulWidget {
  BeaconPage({Key? key}) : super(key: key);

  @override
  State<BeaconPage> createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beacon Page"),
      ),
      body: const Center(
        child: AvatarGlow(
          child: Icon(Icons.phone_iphone_rounded, size: 60),
          endRadius: 200,
          glowColor: Colors.green,
          showTwoGlows: true,
          startDelay: Duration(milliseconds: 1000),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          height: 50,
          child: Center(child: Text('Scaniing for Beacons')),
        ),
      ),
    );
  }

  final regions = <Region>[];

  void initialiseBeaconScanner() async {
    //TODO implement beacon scanner
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
    }

    // start scanning
    flutterBeacon
        .ranging(
      regions,
    )
        .listen((rangingResult) {
      // do something with ranging result
      //show alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Beacon Found'),
            content: Text('Beacon Found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  void diffScanner() async {
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      // Android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

// to start monitoring beacons
    var _streamMonitoring =
        flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
      // result contains a region, event type and event state
      //show alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Beacon Found'),
            content: Text(result.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });

// to stop monitoring beacons
    _streamMonitoring.cancel();
  }
}
