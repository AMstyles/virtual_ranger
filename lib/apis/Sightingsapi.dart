import 'dart:convert';
import 'dart:io';
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
  static void uploadMarker(
      LatLng position, BuildContext context, Sighting currentAnimal) async {
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/add_animal_sighting'), body: {
      'user_id': UserData.user.id,
      'animal_id': currentAnimal.animal_id,
      'plartform': 'mobile',
      'DeviceID': ' ',
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
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
          return AlertDialog(
            title: data['success']
                ? Text(
                    "Success",
                    style: TextStyle(color: Colors.green),
                  )
                : Text(
                    "Error",
                    style: TextStyle(color: Colors.red),
                  ),
            content: Text(data['data'].toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static Future<List<Sighting>> getSightings() async {
    final response = await http.get(Uri.parse(GET_SIGHTINGS_URL));
    print(response.body);
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    print(data);
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
    final response =
        await http.post(Uri.parse(GET_COLOURED_ANIMALS_URL), body: {
      'secret_key':
          Provider.of<UserProvider>(context, listen: false).user!.secret_key ??
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
  }
}
