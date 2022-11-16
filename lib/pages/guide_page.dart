import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/category.dart';
import 'package:virtual_ranger/services/animal_search.dart';
import 'package:virtual_ranger/widgets/CategoryWidg.dart';
import '../apis/Animal&Plants_apis.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';
import 'Custom/AnimeVals.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  Future<bool> getOffline() async {
    return await UserData.getOfflineMode();
  }

  late Future<List<Category_>> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOffline().then((value) {
      setState(() {
        _future = value
            ? Categoryapi.getCategoriesFromLocal()
            : Categoryapi.getCategories();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: const Text("Guide"),
        actions: [
          CupertinoButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              child: const Icon(
                CupertinoIcons.search,
                color: Colors.black,
              ))
        ],
      ),
      body: LiquidPullToRefresh(
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
                      ? Categoryapi.getCategoriesFromLocal()
                      : Categoryapi.getCategories();
            });
          });
        },
        child: FutureBuilder<List<Category_>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return CategoryWidg(category: snapshot.data![index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
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
                                : Text(
                                    "${snapshot.error}",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 19),
                                  ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _future = Provider.of<UserProvider>(context,
                                            listen: false)
                                        .isOffLine ??
                                    false
                                ? Categoryapi.getCategoriesFromLocal()
                                : Categoryapi.getCategories();
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
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
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }
}
