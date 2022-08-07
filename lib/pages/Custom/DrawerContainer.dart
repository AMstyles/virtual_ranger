import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/pages/news_and_deals_page.dart';
import 'package:provider/provider.dart';

class DrawerContainer extends StatefulWidget {
  const DrawerContainer({Key? key}) : super(key: key);

  @override
  State<DrawerContainer> createState() => _DrawerContainerState();
}

class _DrawerContainerState extends State<DrawerContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 4,
          blurRadius: 12,
        )
      ]),
      transform: Matrix4.translationValues(Provider.of<Anime>(context).xOffset,
          Provider.of<Anime>(context).yOffset, 0)
        ..scale(Provider.of<Anime>(context).scaleFactor),
      child: NewsAndDealsPage(),
    );
  }
}
