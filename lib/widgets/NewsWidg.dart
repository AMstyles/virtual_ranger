import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Home/stroy_page.dart';
import '../models/constants.dart';
import '../models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

class NewsWidg extends StatefulWidget {
  NewsWidg({Key? key, required this.story}) : super(key: key);

  News story;

  @override
  State<NewsWidg> createState() => _NewsWidgState();
}

class _NewsWidgState extends State<NewsWidg> {
  late bool connection = false;

  File? imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PageProvider>(context, listen: false).setConnection();
    //isInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewsPage(story: widget.story);
          }));
        },
        child: Hero(
          tag: widget.story.title,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 300,
              width: 300,
              child: Stack(fit: StackFit.expand,
                  //alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (Provider.of<UserProvider>(context)
                                      .isOffLine ??
                                  false)
                              ? !Provider.of<PageProvider>(context)
                                      .hasConnection
                                  ? FileImage(
                                      File(
                                          '${UserData.path}/images/${widget.story.news_image}'),
                                    ) as ImageProvider
                                  : CachedNetworkImageProvider(
                                      NEWS_IMAGE_URL + widget.story.news_image,
                                    )
                              : CachedNetworkImageProvider(
                                  NEWS_IMAGE_URL + widget.story.news_image,
                                ),
                        ),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.only(
                            left: 5, bottom: 2, right: 12),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.7)
                            ])),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //maxLines: 1,
                                //overflow: TextOverflow.ellipsis,
                                widget.story.title,
                                style: TextStyle(
                                    fontSize: 19, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.story.news_post_date,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                widget.story.news_text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
