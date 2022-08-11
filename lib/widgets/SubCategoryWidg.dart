import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/pages/SubcategoryPage.dart';

import '../pages/SpeciesPage.dart';

class SubCategoryWidg extends StatelessWidget {
  const SubCategoryWidg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SpeciesPage();
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(''), fit: BoxFit.fill),
          ),
          child: const Center(
              child: Text(
            'SEEDS EATERS',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
