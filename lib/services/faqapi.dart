import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
