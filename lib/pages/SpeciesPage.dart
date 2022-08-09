import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/animal_search.dart';
import 'package:virtual_ranger/widgets/CategoryWidg.dart';
import 'package:virtual_ranger/widgets/SpecyWidget.dart';

import 'Custom/AnimeVals.dart';

class SpeciesPage extends StatefulWidget {
  SpeciesPage({Key? key}) : super(key: key);

  @override
  State<SpeciesPage> createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView.builder(itemBuilder: ((context, index) {
        return SpecyWidg();
      })),
    );
    ;
  }
}
