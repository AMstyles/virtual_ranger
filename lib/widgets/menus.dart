import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Custom/DrawerItem.dart';

import '../pages/Custom/AnimeVals.dart';
import '../services/page_service.dart';

class DrawerMenu extends StatefulWidget {
  DrawerMenu({Key? key, required this.item}) : super(key: key);

  DrawerItem item;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late Timer myTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<PageProvider>(context, listen: false)
            .switchPage(widget.item.num);
        Provider.of<Anime>(context, listen: false).closeDrawer();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .01, horizontal: 10),
        color:
            (Provider.of<PageProvider>(context, listen: false).currentPageNum !=
                    widget.item.num)
                ? Colors.transparent
                : Colors.white.withOpacity(.2),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Icon(
                  widget.item.icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}