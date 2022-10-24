import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/animalforSIGHT.dart';
import '../models/constants.dart';
import '../services/page_service.dart';

class Sightings {
  static Future<bool> uploadMarker(
      LatLng position, BuildContext context, AnimalSight currentAnimal) async {
    print("uploading marker" + position.toString());
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/add_animal_sighting'), body: {
      'user_id': UserData.user.id,
      'animal_id': currentAnimal.id,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'device_id': Platform.version,
      'lat_seq': position.latitude.toString(),
      'lng_seq': position.longitude.toString(),
      'secret_key':
          Provider.of<UserProvider>(context, listen: false).user!.secret_key ??
              " ",
      'user_role': 'Attendee'
    });

    //print(response.body);
    final data = json.decode(response.body);

    showDialog(
        context: context,
        builder: (context) {
          return Platform.isAndroid
              ? AlertDialog(
                  title: data['success']
                      ? Text(
                          "Success",
                          style: TextStyle(color: Colors.green),
                        )
                      : Text(
                          "Error",
                          style: TextStyle(color: Colors.red),
                        ),
                  content: Text(data['success']
                      ? 'Thank you for your entry.\nYour sighting will be visible for the next 8 hours'
                      : data['data'].toString()),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  title: data['success']
                      ? /*Text(
                          "Success",
                          style: TextStyle(color: Colors.green),
                        )*/
                      SizedBox()
                      : Text(
                          "Error",
                          style: TextStyle(color: Colors.red),
                        ),
                  // content: Text(data['data'].toString()),
                  content: Text(
                    data['success']
                        ? 'Thank you for your entry.\nYour sighting will be visible for the next 8 hours'
                        : data['data'].toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
        });

    return data['success'];
  }

  static Future<List<Sighting>> getSightings() async {
    final response = await http.post(Uri.parse(GET_SIGHTINGS_URL), body: {
      'user_id': UserData.user.id,
      'secret_key': UserData.user.secret_key,
      'user_role': 'Attendee'
    });
    //print(response.body);
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    //print(data);
    final List<dynamic> finalData = data;
    List<Sighting> events = [];
    for (var i = 0; i < finalData.length; i++) {
      events.add(
        Sighting.fromJson(
          finalData[i],
        ),
      );
    }
    return events;
  }

  static Future<List<Sighting>> getSightingsFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/business_listings.json');
    final data = jsonDecode(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
    List<Sighting> events = [];
    for (var i = 0; i < finalData.length; i++) {
      events.add(
        Sighting.fromJson(
          finalData[i],
        ),
      );
    }
    return events;
  }

  static Future<List<AnimalSight>> getColouredAnimal(
      BuildContext context) async {
    try {
      final response =
          await http.post(Uri.parse(GET_COLOURED_ANIMALS_URL), body: {
        'secret_key': Provider.of<UserProvider>(context, listen: false)
                .user!
                .secret_key ??
            " ",
      });

      final pre_data = jsonDecode(response.body);
      final data = pre_data['data'];

      final List<dynamic> finalData = data;
      List<AnimalSight> events = [];
      for (var i = 0; i < finalData.length; i++) {
        events.add(
          AnimalSight.fromJson(
            finalData[i],
          ),
        );
      }
      return events;
    } catch (e) {
      print(e);
      return getColouredAnimal(context);
    }
  }
}
