import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/apis/In.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../models/constants.dart';
import '../models/user.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/models/user.dart';
import 'package:virtual_ranger/pages/sign_up_page.dart';
import 'dart:io' show Platform;

import '../services/page_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late User user;
  late String data;

  late String email;
  late String password;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN IN'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            children: [
              Image.asset(
                'lib/assets/mainLogo.png',
                color: Colors.grey.shade600,
                fit: BoxFit.cover,
              ),
              Platform.isIOS
                  ? _buildAppleSignInButton(context)
                  : const SizedBox(),
              const SizedBox(height: 12),
              _buildFacebookSignInButton(context),
              const SizedBox(height: 12),
              _buildGoogleSignInButton(context),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'OR',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                textAlign: TextAlign.center,
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              _buildSignInButton(context),
              const SizedBox(height: 20),
              _buildSignUpButton(context),
              const SizedBox(height: 20),
              //_buildRow(context),
            ]),
      ),
    );
  }

//!methods
//!recreations

  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSubmit2(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
        ),
        child: const Text(
          'SIGN IN',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
        ),
        child: const Text(
          'SIGN UP/REGISTER',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

//!fancy
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

  Widget space(BuildContext context) {
    return const SizedBox(width: 20);
  }

  //!Sign in method
  void handleSubmit2() async {
    email = _emailController.text;
    password = _passwordController.text;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Loading...'),
        content: CircularProgressIndicator.adaptive(),
      ),
    );

    data = await signUpAPI.signIn(email, password);
    Navigator.pop(context);

    final finalData = jsonDecode(data);

    if (finalData['success'] == true) {
      user = User.fromjson(finalData['data']);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DrawerApp()));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(finalData['data']),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }
    //print(finalData['success']);
  }
}
