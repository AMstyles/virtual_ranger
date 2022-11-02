import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:virtual_ranger/widgets/BLWidg.dart';
import '../apis/businesslistingsapi.dart';
import '../models/BL.dart';
import '../services/page_service.dart';

class BusinessListingsPage extends StatefulWidget {
  BusinessListingsPage({Key? key}) : super(key: key);

  @override
  State<BusinessListingsPage> createState() => _BusinessListingsPageState();
}

class _BusinessListingsPageState extends State<BusinessListingsPage> {
  late Future<List<BusinessListing>> _future =
      Provider.of<UserProvider>(context).isOffLine ?? false
          ? BusinessListingsapi.getBusinessListings()
          : BusinessListingsapi.getBusinessListingsFromLocal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: const Text("Business Listings"),
      ),
      body: LiquidPullToRefresh(
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        springAnimationDurationInMilliseconds: 400,
        height: MediaQuery.of(context).size.height * .20,
        onRefresh: () {
          return Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _future = BusinessListingsapi.getBusinessListings();
            });
          });
        },
        child: ListView(
          children: [
            StickyHeader(
              header: _buildHeader(context, 'Emergency Contact Numbers'),
              content: FutureBuilder<List<BusinessListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].type ==
                              'Emergency Contact Numbers') {
                            return BusinessListingWidg(
                                businessListing: snapshot.data![index]);
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasError) {
                    //return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              ),
            ),

            //!first future builder
            //const SizedBox(height: 10),

            StickyHeader(
              header: _buildHeader(context, 'Accomodation'),
              content: FutureBuilder<List<BusinessListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].type == 'Accommodation') {
                            return BusinessListingWidg(
                                businessListing: snapshot.data![index]);
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasError) {
                    //return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              ),
            ),

            //!first future builder
            //const SizedBox(height: 10),

            StickyHeader(
              header: _buildHeader(context, 'Restaurants'),
              content: FutureBuilder<List<BusinessListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].type == 'Restaurants') {
                            return BusinessListingWidg(
                                businessListing: snapshot.data![index]);
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasError) {
                    //return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              ),
            ),

            //const SizedBox(height: 10),

            //!first future builder
            StickyHeader(
              header: _buildHeader(context, 'Activities'),
              content: FutureBuilder<List<BusinessListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].type == 'Activities') {
                            return BusinessListingWidg(
                                businessListing: snapshot.data![index]);
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasError) {
                    //return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              ),
            ),

            //const SizedBox(height: 10),
            //!first future builder
            StickyHeader(
              header: _buildHeader(context, 'Services'),
              content: FutureBuilder<List<BusinessListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].type == 'Services') {
                            return BusinessListingWidg(
                                businessListing: snapshot.data![index]);
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasError) {
                    //return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              ),
            ),
            FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: Center(
                          child: Text(
                        'That is all :)',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Column(
                        children: [
                          Icon(Icons.sync_problem,
                              color: Colors.red.withOpacity(.7), size: 80),
                          Text(
                            'Something went wrong ',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          Text(
                            'pull down to refresh',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      )),
                    );
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
