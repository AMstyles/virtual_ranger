import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: const Text("BusinessListings"),
      ),
      body: ListView(
        children: [
          _buildHeader(context, 'Emergency Contact Numbers'),
          FutureBuilder<List<BusinessListing>>(
            future: Provider.of<UserProvider>(context).isOffLine ?? false
                ? BusinessListingsapi.getBusinessListingsFromLocal()
                : BusinessListingsapi.getBusinessListings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
          const SizedBox(height: 10),
          _buildHeader(context, 'Accomodation'),
          FutureBuilder<List<BusinessListing>>(
            future: BusinessListingsapi.getBusinessListings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
          const SizedBox(height: 10),
          _buildHeader(context, 'Restaurants'),
          FutureBuilder<List<BusinessListing>>(
            future: BusinessListingsapi.getBusinessListings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
          const SizedBox(height: 10),
          _buildHeader(context, 'Activities'),
          FutureBuilder<List<BusinessListing>>(
            future: BusinessListingsapi.getBusinessListings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
          const SizedBox(height: 10),
          _buildHeader(context, 'Services'),
          FutureBuilder<List<BusinessListing>>(
            future: BusinessListingsapi.getBusinessListings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ],
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
