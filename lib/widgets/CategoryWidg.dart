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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(stories[0].Imageurl), fit: BoxFit.fill),
        ),
        child: const Center(
            child: Text(
          'INSECTS',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
