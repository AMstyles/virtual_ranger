import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/faq.dart';

const String FAQ_URL = 'https://dinokengapp.co.za/get_content?title=FAQ';

class FAQapi {
  static Future<List<FAQ>> getFAQ() async {
    final response = await http.get(Uri.parse(FAQ_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<FAQ> faqs = [];
    for (var i = 0; i < finalData.length; i++) {
      faqs.add(FAQ.fromJson(finalData[i]));
    }
    return faqs;
  }

  static Future<List<FAQ>> getFAQFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/faq.json');
    final data = file.readAsStringSync();
    final pre_data = jsonDecode(data);
    final List<dynamic> finalData = pre_data['data'];
    List<FAQ> faqs = [];
    for (var i = 0; i < finalData.length; i++) {
      faqs.add(FAQ.fromJson(finalData[i]));
    }
    return faqs;
  }
}
