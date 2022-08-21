import 'package:virtual_ranger/models/BL.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constants.dart';

class BusinessListingsapi {
  static Future<List<BusinessListing>> getBusinessListings() async {
    final response = await http.get(Uri.parse(BUSINESS_LISTINGS_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    print(data);
    final List<dynamic> finalData = data;
    List<BusinessListing> events = [];
    for (var i = 0; i < finalData.length; i++) {
      events.add(
        BusinessListing.fromJson(
          finalData[i],
        ),
      );
    }
    return events;
  }
}
