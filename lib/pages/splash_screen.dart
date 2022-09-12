import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/pages/sign_in_page.dart';
import 'sign_up_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _yOffset = 0;
  double _opacity = 0;
  double _opacity2 = 0;
  @override
  void initState() {
    super.initState();
    //startUser();
    setState(() {
      _yOffset = 0;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _yOffset = -MediaQuery.of(context).size.height * .7;
        _opacity2 = 1;
      });
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _opacity = 1;
      });
    });
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
          AnimatedOpacity(
            opacity: _opacity2,
            duration: Duration(milliseconds: 1000),
            child: AnimatedContainer(
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 700),
              transform: Matrix4.translationValues(0, _yOffset, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    height: 150,
                    'lib/assets/dinokeng_logo.png',
                    color: Colors.white,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Dinokeng',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeContent(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 1000),
      child: DecoratedBox(
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
      ),
    );
  }
}
