import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/animal_search.dart';
import 'package:virtual_ranger/widgets/CategoryWidg.dart';

import '../widgets/SubCategoryWidg.dart';
import 'Custom/AnimeVals.dart';

class SubcategoryPage extends StatefulWidget {
  SubcategoryPage({Key? key}) : super(key: key);

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("subCat name"),
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
      body: ListView.builder(itemBuilder: ((context, index) {
        return SubCategoryWidg();
      })),
    );
    ;
  }
}
