import 'dart:io';

import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = [
    'Elephant',
    'Zebra',
    'Lion',
    'Heyna',
    'Tiger',
    'Rhino',
    'monkey',
    'Wild Dog',
  ];
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
    List<String> match = [];
    for (String fruit in searchItems) {
      if (fruit.contains(query)) {
        match.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: match.length,
        itemBuilder: ((context, index) {
          String result = match[index];
          return ListTile(
            title: Text(result),
          );
        }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> match = [];
    for (String fruit in searchItems) {
      if (fruit.contains(query)) {
        match.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: match.length,
        itemBuilder: ((context, index) {
          String result = match[index];
          return ListTile(
            onTap: () {},
            title: Text(result),
          );
        }));
  }
}
