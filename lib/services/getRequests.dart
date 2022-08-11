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
  //print(data[1]);
  return data;
}

dynamic getFAQ() async {
  final response = await http.get(Uri.parse(FAQ_URL));
  //print(response.body);
  final pre_data = jsonDecode(response.body);
  //print(pre_data);
  final data = pre_data['data'];
  //print(data);
  //print(data[2]['title']);
  //final List<dynamic> finalData = jsonDecode(data);
  //print(finalData[0]);
  //print(final_data['title']);
  //print(data[1]);

  dynamic finalData = data[1][2];

  print(finalData);
  return data;
}

String something() {
  return getFAQ();
}
