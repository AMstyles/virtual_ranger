import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/pages/Home/deals_tab.dart';
import 'package:virtual_ranger/pages/Home/news_tab.dart';
import 'package:virtual_ranger/services/getRequests.dart';
import 'Custom/AnimeVals.dart';

class NewsAndDealsPage extends StatefulWidget {
  NewsAndDealsPage({Key? key, k}) : super(key: key);

  @override
  State<NewsAndDealsPage> createState() => _NewsAndDealsPageState();
}

class _NewsAndDealsPageState extends State<NewsAndDealsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              unselectedLabelColor: Colors.green,
              automaticIndicatorColorAdjustment: true,
              enableFeedback: true,
              labelColor: Colors.green.shade700,
              tabs: [
                Tab(
                    child: Text('News',
                        style: TextStyle(
                          fontSize: 17,
                        ))),
                Tab(
                    child: Text('Deals',
                        style: TextStyle(
                          fontSize: 17,
                        )))
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
