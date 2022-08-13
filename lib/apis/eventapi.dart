import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constants.dart';
import '../models/event.dart';

class Eventapi {
  static Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse(EVENT_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<Event> events = [];
    for (var i = 0; i < finalData.length; i++) {
      events.add(Event.fromJson(finalData[i]));
    }
    return events;
  }
}
