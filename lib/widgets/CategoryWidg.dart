import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/news.dart';
import 'package:virtual_ranger/pages/SubcategoryPage.dart';

class CategoryWidg extends StatelessWidget {
  const CategoryWidg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SubcategoryPage();
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(''), fit: BoxFit.cover),
          ),
          child: const Center(
              child: Text(
            'INSECTS',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
