import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_ranger/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class Sightings {
  static void uploadMarker(LatLng position, BuildContext context) async {
    final respponse = await http.post(
      Uri.parse('http://dinokengapp.co.za/add_animal_sighting'),
      body: json.encode({
        'user_id': UserData.user.id,
        'animal_id': 5,
        'plartform': 'mobile',
        'DeviceID': ' ',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'secret_key': UserData.user.secret_key,
      }),
    );
    print("all done");
    print(respponse.body);
    final data = json.decode(respponse.body);
    //loop that prints 10 times
    for (var i = 0; i < 10; i++) {
      print(UserData.user.secret_key);
    }

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
            content: Text(data['data']),
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
}
