import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/category.dart';
import 'package:virtual_ranger/pages/SubcategoryPage.dart';

import '../models/constants.dart';

class CategoryWidg extends StatelessWidget {
  CategoryWidg({Key? key, required this.category}) : super(key: key);

  Category_ category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SubcategoryPage(
            curr: category,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image:
                    NetworkImage(CATEGORY_IMAGE_URL + category.backgroundImage),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: Text(
            category.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
