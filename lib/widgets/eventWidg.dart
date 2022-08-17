import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/event.dart';
import '../models/constants.dart';
import '../pages/Home/event_page.dart';

class EventWidg extends StatelessWidget {
  EventWidg({Key? key, required this.event}) : super(key: key);
  Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EventPage(event: event)));
        },
        child: Hero(
          tag: event.title,
          child: Container(
            //height: 200,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fit: BoxFit.cover,
                NEWS_IMAGE_URL + event.event_image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
