import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/category.dart';
import 'package:virtual_ranger/services/animal_search.dart';
import '../models/subCategory.dart';
import '../services/page_service.dart';
import '../widgets/SubCategoryWidg.dart';
import '../apis/Animal&Plants_apis.dart';

class SubcategoryPage extends StatefulWidget {
  SubcategoryPage({Key? key, required this.curr}) : super(key: key);

  Category_ curr;

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curr.name),
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
      body: FutureBuilder<List<SubCategory>>(
        future: Provider.of<UserProvider>(context).isOffLine ?? true
            ? SubCategoryapi.getSubCategoriesFromLocal()
            : SubCategoryapi.getSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index].categoryId == widget.curr.id
                    ? SubCategoryWidg(
                        subCategory: snapshot.data![index],
                      )
                    : const SizedBox();
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
