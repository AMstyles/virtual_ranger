import 'dart:convert';
import 'package:virtual_ranger/models/constants.dart';
import 'package:http/http.dart' as http;

dynamic getNews() async {
  final response = await http.get(Uri.parse(NEWS_URL));
  //print(response.body);
  final pre_data = jsonDecode(response.body);
  //print(pre_data);

  final data = pre_data['data'];
  //print(data[2]['title']);
  //final List<dynamic> finalData = jsonDecode(data);
  //print(finalData[0]);
  //print(final_data['title']);
  print(data[1]);
  return data;
}
