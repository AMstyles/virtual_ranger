import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/widgets/NewsWidg.dart';

import '../../apis/newsapi.dart';

class NewsTab extends StatefulWidget {
  NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin<NewsTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: Provider.of<UserProvider>(context).isOffLine ?? false
          ? Newsapi.getNewsFromLocal()
          : Newsapi.getNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return NewsWidg(story: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
