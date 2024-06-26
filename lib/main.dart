import 'dart:io';
import 'apis/Download.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtual_ranger/pages/prePage.dart';
import 'package:virtual_ranger/services/readyData.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/services/LoginProviders.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  await UserData.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    beginApp();
  }

  void beginApp() async {
    try {
      await DownLoad.downloadAllJson();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapsData(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppleLoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Anime(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DownloadProvider(),
        ),
      ],
      child: InAppNotification(
        child: MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.green,
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: PrepPage(),
        ),
      ),
    );
  }
}
