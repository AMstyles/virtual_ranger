import 'dart:io';
import 'package:flutter/material.dart';
import '../models/constants.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SIGN UP'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            Image.asset(
              'lib/assets/mainLogo.png',
              color: Colors.grey.shade600,
              fit: BoxFit.cover,
            ),
            Platform.isIOS
                ? _buildAppleSignInButton(context)
                : const SizedBox(),
            _makeSpace(context),
            _buildFacebookSignInButton(context),
            _makeSpace(context),
            _buildGoogleSignInButton(context),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'OR',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Name and Surname',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            _buildRadioButtonGroup(context),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'confirm password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            _makeSpace(context),
            _buildSignUpButton(context),
          ],
        ));
  }

  //!remakes

  Widget _buildSignUpButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
      ),
      child: const Text(
        'REGISTER',
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }

  //!fancy
  Widget _buildGoogleSignInButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      height: 45,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              'lib/assets/googleIcon.png',
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            "Sign in with Google",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleSignInButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      height: 45,
      width: 140,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(
            Icons.apple,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(width: 20),
          Text(
            "Sign in with Apple",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _makeSpace(BuildContext context) {
    return const SizedBox(height: 10);
  }

  Widget _buildFacebookSignInButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      height: 45,
      width: 140,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(
            size: 40,
            Icons.facebook,
            color: Colors.white,
          ),
          SizedBox(width: 20),
          Text(
            "Sign in with Facebook",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  //!experimental
  //function that make a group of two radio buttons
  Widget _buildRadioButtonGroup(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: 1,
                onChanged: (value) {},
              ),
              const Text('male'),
            ],
          ),
          Row(
            children: [
              Radio(value: 2, groupValue: 1, onChanged: (value) {}),
              const Text('female'),
            ],
          ),
          const Text(
            '(Optional)',
            style: TextStyle(color: Colors.blueGrey),
          )
        ],
      ),
    );
  }
}
