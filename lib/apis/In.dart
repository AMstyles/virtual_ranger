import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final response =
        await http.post(Uri.parse('https://dinokengapp.co.za/login'), body: {
      'email': email,
      'password': password,
    });
    print(response.body);
    final data = response.body;

    return data;
  }

  static Future<String> updateProfile(
    String name,
    String email,
    String phone,
    String country,
    String city,
    //String age_range,
    String password,
    String password_confirm,
  ) async {
    final response = await http
        .post(Uri.parse('https://dinokengapp.co.za/edit_profile'), body: {
      'name': name,
      'email': email,
      'mobile': '0711281932',
      'password': password,
      'confirm_password': password_confirm,
      'user_role': 'Attendee',
      'city': city,
      'country': country,
      //'age_range':age_range,
    });
    final data = response.body;
    print(data);

    return data;
  }
}
