import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/page_service.dart';

import '../apis/Animal&Plants_apis.dart';
import '../models/Specy.dart';
import '../widgets/SpecyWidget.dart';

class CustomSearchDelegate extends SearchDelegate {
  late List<Specy> searchItems = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query.isEmpty ? close(context, null) : query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading

    IconButton(
      icon: Platform.isAndroid
          ? const Icon(Icons.arrow_back)
          : const Icon(Icons.arrow_back_ios),
      /*icon: const Icon(Icons.arrow_back_ios),*/
      onPressed: () => close(context, null),
    );
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<Specy> match = [];
    for (var i = 0; i < searchItems.length; i++) {
      if (searchItems[i]
          .english_name
          .toLowerCase()
          .contains(query.toLowerCase())) {
        match.add(searchItems[i]);
      }
    }
    return FutureBuilder<List<Specy>>(
      future: Provider.of<UserProvider>(context).isOffLine ?? false
          ? Specyapi.getSpeciesFromLocal()
          : Specyapi.getSpecies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (query.isEmpty) {
            return const Center(
                child: Text(
              'Your Text query is empty',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              reverse: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                //searchItems.add(snapshot.data![index]);
                if (snapshot.data![index].english_name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  return SpecyWidg(
                    specy: snapshot.data![index],
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return FutureBuilder<List<Specy>>(
      future: Provider.of<UserProvider>(context).isOffLine ?? false
          ? Specyapi.getSpeciesFromLocal()
          : Specyapi.getSpecies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (query.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 23),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SpecyWidg(
                  specy: snapshot.data![index],
                );
              },
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 23),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                //searchItems.add(snapshot.data![index]);
                if (snapshot.data![index].english_name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  return SpecyWidg(
                    specy: snapshot.data![index],
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
