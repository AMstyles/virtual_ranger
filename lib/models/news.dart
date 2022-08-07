import 'package:flutter/material.dart';

class News {
  final String title;
  final String date;
  //dateOfDay alternatively;
  final Text body;

  News({required this.title, required this.date, required this.body});
}
