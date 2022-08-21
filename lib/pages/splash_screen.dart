import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/sign_in_page.dart';

import 'sign_up_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              image: Image.asset('lib/assets/splash.jpg').image,
              fit: BoxFit.cover),
        ),
        child: makeContent(context),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //!sign up button

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
    );
  }
}
