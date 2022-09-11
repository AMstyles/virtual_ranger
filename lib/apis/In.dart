import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class signUpAPI {
  static Future<String> signUp(
      String name,
      String email,
      String mobile,
      String gender,
      String age_ranger,
      String password,
      String password_confirm) async {
    final response =
        await http.post(Uri.parse('https://dinokengapp.co.za/signup'), body: {
      'accept_term': '1',
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'confirm_password': password_confirm,
      'user_role': 'Attendee',
      'age_range': age_ranger,
      'country': 'Unknown',
      'gender': gender,
    });
    final data = response.body;
    return data;
  }

  static Future<String> signUpG(
      String name,
      String email,
      String mobile,
      String gender,
      String age_ranger,
      String password,
      String password_confirm,
      String profile_image) async {
    final response =
        await http.post(Uri.parse('https://dinokengapp.co.za/signup'), body: {
      'accept_term': '1',
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'confirm_password': password_confirm,
      'user_role': 'Attendee',
      'age_range': age_ranger,
      'country': '',
      'city': '',
      'gender': gender,
      'profile_image': profile_image
    });
    final data = response.body;
    return data;
  }

  static Future<String> signIn(String email, String password) async {
    final response = await http
        .post(Uri.parse('https://dinokengapp.co.za/attendee_login'), body: {
      'email': email,
      'password': password,
    });
    print(response.body);
    final data = response.body;

    return data;
  }

  static Future<String> signInWithGoogle(String email) async {
    final response = await http
        .post(Uri.parse('https://dinokengapp.co.za/google_login'), body: {
      'email': email,
    });
    print(response.body);
    final data = response.body;
    return data;
  }

  static Future<String> updatePassword(String id, String email, String password,
      String password_confirm, String secret_key) async {
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/edit_profile'), body: {
      'id': id,
      'email': email,
      'password': password,
      'confirm_password': password_confirm,
      'secret_key': secret_key,
      'user_role': 'Attendee',
    });
    final data = response.body;
    print(data);
    return data;
  }

  static Future<String> updateProfile(
    String id,
    String name,
    String email,
    String phone,
    String age_range,
    String gender,
    String country,
    String city,
    String secretKey,
  ) async {
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/edit_profile'), body: {
      'id': id,
      'name': name,
      'email': email,
      'mobile': phone,
      'country': country,
      'gender': gender,
      'age_range': age_range,
      'secret_key': secretKey,
      'user_role': 'Attendee',
      'city': city,
    });

    final data = response.body;
    print(data);

    return data;
  }

  static Future<void> forgotPassword(String email, BuildContext context) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text('Please wait...'),
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }));
    final response = await http
        .post(Uri.parse('https://dinokengapp.co.za/forgot_password'), body: {
      'email': email,
    });
    Navigator.pop(context);

    final data = response.body;
    final finalData = jsonDecode(data);

    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(finalData['success'] ? 'Success' : 'Error'),
            content: Text(finalData['data']),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'))
            ],
          );
        }));
    print(response.body);
  }
}
