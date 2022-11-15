import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/widgets/NewsWidg.dart';
import '../../apis/newsapi.dart';
import '../../services/shared_preferences.dart';

class NewsTab extends StatefulWidget {
  NewsTab({Key? key}) : super(key: key);
  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin<NewsTab> {
  late Future<List<News>> _future =
      Provider.of<UserProvider>(context).isOffLine ?? false
          ? Newsapi.getNewsFromLocal()
          : Newsapi.getNews();

  Future<bool> getOffline() async {
    return await UserData.getOfflineMode();
  }

  @override
  void initState() {
    super.initState();
    getOffline().then((value) {
      value
          ? _future = Newsapi.getNewsFromLocal()
          : _future = Newsapi.getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      springAnimationDurationInMilliseconds: 500,
      animSpeedFactor: 2,
      height: MediaQuery.of(context).size.height * .20,
      onRefresh: () {
        return Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _future =
                Provider.of<UserProvider>(context, listen: false).isOffLine ??
                        false
                    ? Newsapi.getNewsFromLocal()
                    : Newsapi.getNews();
          });
        });
      },
      child: FutureBuilder<List<News>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: Colors.green,
                inverted: true,
                size: 50,
              ),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return NewsWidg(story: snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: ListView(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          snapshot.error
                                  .toString()
                                  .toLowerCase()
                                  .contains("dinokeng")
                              ? const Text(
                                  "No Internet Connection",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 19),
                                )
                              : const Text(
                                  "Error",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 19),
                                ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _future =
                              Provider.of<UserProvider>(context, listen: false)
                                          .isOffLine ??
                                      false
                                  ? Newsapi.getNewsFromLocal()
                                  : Newsapi.getNews();
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green,
                                width: 1,
                              )),
                          child: Text("Retry")),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: MyColors.primaryColor,
                duration: Duration(milliseconds: 500),
                inverted: true,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
