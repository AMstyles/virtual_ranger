import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Home/deals_tab.dart';
import 'package:virtual_ranger/pages/Home/news_tab.dart';
import 'Custom/AnimeVals.dart';

class NewsAndDealsPage extends StatefulWidget {
  NewsAndDealsPage({Key? key, k}) : super(key: key);

  @override
  State<NewsAndDealsPage> createState() => _NewsAndDealsPageState();
}

class _NewsAndDealsPageState extends State<NewsAndDealsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(labelColor: Colors.black, tabs: [
            Tab(
              text: 'News',
            ),
            Tab(
              text: 'Deals',
            )
          ]),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
          elevation: 0,
          title: const Text("NEWS & DEALS"),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          NewsTab(),
          DealsTab(),
        ]),
      ),
    );
  }
}
