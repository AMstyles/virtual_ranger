import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/page_service.dart';

class signUpAPI {
  static Future<String> signUp(String name, String email, String password,
      String password_confirm) async {
    final response =
        await http.post(Uri.parse('https://dinokengapp.co.za/signup'), body: {
      'accept_term': '1',
      'name': name,
      'email': email,
      'mobile': '0711281932',
      'password': password,
      'confirm_password': password_confirm,
      'user_role': 'Attendee'
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

  static Future<String> updatePassword(String id, String email, String password,
      String password_confirm, String secret_key) async {
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/edit_profile'), body: {
      'id': id,
      'email': email,
      'password': password,
      'confirm_password': password_confirm,
      'secret_key': secret_key,
      'user_role': 'Attendee'
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

    //String thing,
  ) async {
    final response = await http
        .post(Uri.parse('http://dinokengapp.co.za/edit_profile'), body: {
      'id': id,
      'name': name,
      'email': email,
      'mobile': '0711281932',
      'age_range': age_range,
      'secret_key': secretKey,
      'user_role': 'Attendee',
      'city': city,
      //'country': country,
      //'age_range':age_range,
    });
    final data = response.body;
    print(data);

    return data;
  }
}
