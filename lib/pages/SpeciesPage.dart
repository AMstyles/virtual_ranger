import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/models/Specy.dart';
import 'package:virtual_ranger/models/subCategory.dart';
import 'package:virtual_ranger/services/animal_search.dart';
import 'package:virtual_ranger/widgets/SpecyWidget.dart';

class SpeciesPage extends StatefulWidget {
  SpeciesPage({Key? key, required this.subCategory}) : super(key: key);
  SubCategory subCategory;

  @override
  State<SpeciesPage> createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategory.name),
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
      body: FutureBuilder<List<Specy>>(
        future: Specyapi.getSpecies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (snapshot.data![index].subcategory_id ==
                    widget.subCategory.id) {
                  return SpecyWidg(
                    specy: snapshot.data![index],
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
