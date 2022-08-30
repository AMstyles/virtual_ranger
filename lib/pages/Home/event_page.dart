import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';

import '../../models/event.dart';
import '../../services/page_service.dart';
import '../../services/shared_preferences.dart';

class EventPage extends StatelessWidget {
  EventPage({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 100,
        ),
        children: [
          Hero(
              tag: event.title,
              child: Provider.of<UserProvider>(context).isOffLine ?? false
                  ? Image.file(File('${UserData.path}/${event.event_image}'))
                  : CachedNetworkImage(
                      imageUrl: NEWS_IMAGE_URL + event.event_image,
                    )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                      fontSize: 24,
                    )),
                const SizedBox(height: 5),
                Text('${event.start_date} - ${event.end_date}'),
                const SizedBox(height: 15),
                Text(
                  event.description,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
