import 'package:flutter/material.dart';

import '../extensions/colorExtension.dart';

class AnimalSight {
  String name;
  String id;
  Color color;

  AnimalSight({
    required this.name,
    required this.id,
    required this.color,
  });

  static AnimalSight fromJson(Map<String, dynamic> json) {
    return AnimalSight(
      name: json['english_name'],
      id: json['id'],
      color: HexColor.fromHex(json['pin_color']),
    );
  }
}

class Sighting {
  double latitude;
  double longitude;
  String animal_id;
  TimeOfDay sighting_time;

  Sighting({
    required this.latitude,
    required this.longitude,
    required this.animal_id,
    required this.sighting_time,
  });

  static Sighting fromJson(Map<String, dynamic> json) {
    return Sighting(
      latitude: json['latitude'],
      longitude: json['longitude'],
      animal_id: json['animal_id'],
      sighting_time: json['sighting_time'],
    );
  }
}
