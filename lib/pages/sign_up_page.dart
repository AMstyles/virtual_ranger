import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/apis/In.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../models/constants.dart';
import '../models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String data;
  late User user;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late String name;
  late String email;
  late String password;
  late String confirmPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name and Surname',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            //_buildRadioButtonGroup(context),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
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
    return GestureDetector(
      onTap: () => handleSubmit(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
        ),
        child: const Text(
          'REGISTER',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
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

  //!Sign in method
  void handleSubmit() async {
    name = _nameController.text;
    email = _emailController.text;
    password = _passwordController.text;
    confirmPassword = _confirmPasswordController.text;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Loading...'),
        content: CircularProgressIndicator.adaptive(),
      ),
    );

    data = await signUpAPI.signUp(name, email, password, confirmPassword);
    Navigator.pop(context);

    final finalData = jsonDecode(data);
    print(data);
    if (finalData['success'] == true) {
      user = User.fromjson(finalData['data']);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DrawerApp()));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
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
