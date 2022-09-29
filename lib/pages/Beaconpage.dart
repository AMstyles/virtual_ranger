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
  void initBeacon() async {
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
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

  void scanner1() async {
    print('running scanner');
    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'denokeng',
          proximityUUID: 'e2c56db5-dffb-48d2-b060-d0f5a71096e0'));
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
          proximityUUID: 'e2c56db5-dffb-48d2-b060-d0f5a71096e0'));
    } else {
      // Android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

// to start monitoring beacons
    var _streamMonitoring =
        flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
      // result contains a region, event type and event state
      print("scanner two catched");
      print(result);
    });

// to stop monitoring beacons
    _streamMonitoring.cancel();
  }
}
