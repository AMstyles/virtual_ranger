import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocationApi {
  //funtion to get location data
  static Future<void> getCurrentLocation(BuildContext context) async {
    await Permission.location.request();

    Location location = Location();

    final _locationData = await location.getLocation();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Location'),
              content: Text(_locationData.toString()),
            ));

    /*print(_locationData.latitude);
    print(_locationData.longitude);

    return {
      'latitude': _locationData.latitude!,
      'longitude': _locationData.longitude!,
    };*/
  }
}
