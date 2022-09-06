import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ranger/apis/In.dart';
import '../models/constants.dart';

class ForgortPage extends StatefulWidget {
  const ForgortPage({Key? key}) : super(key: key);

  @override
  State<ForgortPage> createState() => _ForgortPageState();
}

class _ForgortPageState extends State<ForgortPage> {
  late TextEditingController _emailController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialise controlle
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'We will sent you an email with futher instructions to reset your password',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              color: MyColors.primaryColor,
              onPressed: () {
                signUpAPI.forgotPassword(_emailController.text.trim(), context);
              },
              child: const Text(
                'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
