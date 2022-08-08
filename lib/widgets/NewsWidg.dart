import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/Home/stroy_page.dart';
import '../models/news.dart';
import '../models/preset_styles.dart';

class NewsWidg extends StatelessWidget {
  NewsWidg({Key? key, required this.story}) : super(key: key);

  News story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewsPage(story: story);
          }));
        },
        child: SizedBox(
          height: 300,
          width: 300,
          child: Stack(fit: StackFit.expand,
              //alignment: Alignment.bottomCenter,
              children: [
                Hero(
                  tag: story.title,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(story.Imageurl),
                        ),
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.1)
                        ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          style: drawerTextStyle,
                        ),
                        Text(
                          story.date,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          story.body.toString(),
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
