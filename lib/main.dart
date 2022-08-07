import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'DrawerApp.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Anime(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              elevation: 0,
              scrolledUnderElevation: 5,
              centerTitle: true,
              titleTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              actionsIconTheme: IconThemeData(color: Colors.black)),
        ),
        debugShowCheckedModeBanner: false,
        home: const DrawerApp(),
      ),
    );
  }
}
