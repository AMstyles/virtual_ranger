import 'dart:ffi';

import 'package:flutter/material.dart';

import '../extensions/colorExtension.dart';

class AnimalSight {
  String name;
  String id;
  Color color;
  String hexColor;

  AnimalSight(
      {required this.name,
      required this.id,
      required this.color,
      required this.hexColor});

  static AnimalSight fromJson(Map<String, dynamic> json) {
    return AnimalSight(
        name: json['english_name'] ?? 'Unknown',
        id: json['id'] ?? '0',
        color: HexColor.fromHex(json['pin_color'] ?? '#000000'),
        hexColor: json['pin_color'] ?? '#000000');
  }
}

class Sighting {
  double latitude;
  double longitude;
  String animal_id;
  String sighting_time;

  Sighting({
    required this.latitude,
    required this.longitude,
    required this.animal_id,
    required this.sighting_time,
  });

  static Sighting fromJson(Map<String, dynamic> json) {
    return Sighting(
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      animal_id: json['animal_id'],
      sighting_time: json['sighting_time'],
    );
  }
}
