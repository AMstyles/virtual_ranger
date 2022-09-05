import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/pages/sign_in_page.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import '../models/user.dart';
import 'sign_up_page.dart';
import 'package:show_up_animation/show_up_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _alignment = Alignment.bottomCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUser();
    setState(() {
      _alignment = Alignment.topCenter;
    });
  }

  Future<void> startUser() async {
    print(await UserData.isLoggedIn());
    if (await UserData.isLoggedIn() == true) {
      print(await UserData.isLoggedIn());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DrawerApp()));
    }
    Future<User> user = UserData.getUser();
    Provider.of<UserProvider>(context, listen: false).setUser(await user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0),
                ],
              ),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('lib/assets/splashscreenbg.png').image,
                  fit: BoxFit.cover),
            ),
            child: makeContent(context),
          ),
          ShowUpAnimation(
            key: UniqueKey(),
            delayStart: Duration(milliseconds: 100),
            animationDuration: Duration(seconds: 2),
            curve: Curves.linear,
            direction: Direction.vertical,
            offset: 0.9,
            child: Positioned(
                child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  height: 150,
                  'lib/assets/dinokeng_logo.png',
                  color: Colors.white,
                ),
              ],
              
            )),
          ),
        ],
      ),
    );
  }

  Widget makeContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.center,
          colors: [
            Colors.black.withOpacity(.4),
            Colors.black.withOpacity(0),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            //!sign up button

            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SignUpPage();
                }));
              },
              child: Container(
                alignment: Alignment.center,
                height: 45,
                width: 140,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
