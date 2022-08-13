import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/subCategory.dart';

import '../models/constants.dart';
import '../pages/SpeciesPage.dart';

class SubCategoryWidg extends StatelessWidget {
  SubCategoryWidg({Key? key, required this.subCategory}) : super(key: key);

  SubCategory subCategory;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SpeciesPage(subCategory: subCategory);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    SUBCATEGORY_IMAGE_URL + subCategory.BackgroundImage),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: Text(
            subCategory.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
