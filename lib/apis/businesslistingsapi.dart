import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:virtual_ranger/models/BL.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constants.dart';

class BusinessListingsapi {
  static Future<List<BusinessListing>> getBusinessListings() async {
    final response = await http.get(Uri.parse(BUSINESS_LISTINGS_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    //print(data);
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

  static Future<List<BusinessListing>> getBusinessListingsFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/business_listings.json');
    final data = jsonDecode(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
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
