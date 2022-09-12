import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/page_service.dart';

class DrawerContainer extends StatelessWidget {
  DrawerContainer({Key? key}) : super(key: key);

  //pages

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Provider.of<Anime>(context).closeDrawer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 12,
          )
        ]),
        transform: Matrix4.translationValues(
            Provider.of<Anime>(context).xOffset,
            Provider.of<Anime>(context).yOffset,
            0)
          ..scale(Provider.of<Anime>(context).scaleFactor),
        child: AbsorbPointer(
          absorbing: Provider.of<Anime>(context).isOpen ? true : false,
          //child: pages[Provider.of<PageProvider>(context).currentPageNum],
          child: IndexedStack(
            index: Provider.of<PageProvider>(context).currentPageNum,
            children: mainPages,
          ),
        ),
      ),
    );
  }
}
