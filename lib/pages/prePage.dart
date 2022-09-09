import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/splash_screen.dart';
import '../DrawerApp.dart';
import '../models/constants.dart';
import '../models/user.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

class PrepPage extends StatefulWidget {
  const PrepPage({Key? key}) : super(key: key);

  @override
  State<PrepPage> createState() => _PrepPageState();
}

class _PrepPageState extends State<PrepPage> {
  String? _msg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _msg ?? '',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingBouncingGrid.circle(
            size: 100,
            backgroundColor: MyColors.primaryColor,
            duration: Duration(seconds: 1),
            inverted: true,
          ),
          Text(
            'Preparing for your adventure...',
            style: TextStyle(color: Colors.green),
          ),
        ],
      )),
    );
  }

  Future<void> startUser() async {
    print(await UserData.isLoggedIn());
    if (await UserData.isLoggedIn() == true) {
      print(await UserData.isLoggedIn());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DrawerApp()));
      Future<User> user = UserData.getUser();
      Provider.of<UserProvider>(context, listen: false).setUser(await user);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }
}
