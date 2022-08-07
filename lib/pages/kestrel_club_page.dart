import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Custom/AnimeVals.dart';

class Kestrel_club_page extends StatefulWidget {
  Kestrel_club_page({Key? key}) : super(key: key);

  @override
  State<Kestrel_club_page> createState() => _Kestrel_club_pageState();
}

class _Kestrel_club_pageState extends State<Kestrel_club_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: Text("Kestrel Club"),
      ),
    );
    ;
  }
}
