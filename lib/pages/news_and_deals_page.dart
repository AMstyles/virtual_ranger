import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Custom/AnimeVals.dart';

class NewsAndDealsPage extends StatefulWidget {
  NewsAndDealsPage({Key? key, k}) : super(key: key);

  @override
  State<NewsAndDealsPage> createState() => _NewsAndDealsPageState();
}

class _NewsAndDealsPageState extends State<NewsAndDealsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        elevation: 0,
        title: const Text("NEWS & DEALS"),
        centerTitle: true,
      ),
      body: const Center(child: FlutterLogo()),
    );
  }
}
