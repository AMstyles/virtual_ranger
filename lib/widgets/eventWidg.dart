import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/event.dart';
import '../models/constants.dart';
import '../pages/Home/event_page.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

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
        child: Container(
          //height: 200,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Provider.of<UserProvider>(context).isOffLine ?? false
                    ? Image.file(
                        File('${UserData.path}/images/${event.event_image}'),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * .35,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              semanticsValue:
                                  '${event.title} ${progress.progress}',
                            ),
                          );
                        },
                        imageUrl: NEWS_IMAGE_URL + event.event_image,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 5, bottom: 2, right: 12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.7)
                        ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //maxLines: 1,
                          //overflow: TextOverflow.ellipsis,
                          event.title,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${event.start_date}  -  ${event.end_date}',
                          //event.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Dinokeng Game Reserve',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
