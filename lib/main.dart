import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/hidden_drawer.dart';
import 'package:virtual_ranger/pages/news_and_deals_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HiddenDrawer(),
    );
  }
}
