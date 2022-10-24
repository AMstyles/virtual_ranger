import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/category.dart';
import 'package:virtual_ranger/pages/SubcategoryPage.dart';
import 'package:virtual_ranger/services/page_service.dart';

import '../models/constants.dart';
import '../services/shared_preferences.dart';

class CategoryWidg extends StatefulWidget {
  CategoryWidg({Key? key, required this.category}) : super(key: key);

  Category_ category;

  @override
  State<CategoryWidg> createState() => _CategoryWidgState();
}

class _CategoryWidgState extends State<CategoryWidg> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SubcategoryPage(
            curr: widget.category,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: Provider.of<UserProvider>(context).isOffLine ?? false
                    ? FileImage(File(
                            '${UserData.path}/images/${widget.category.backgroundImage}'))
                        as ImageProvider
                    : CachedNetworkImageProvider(
                        CATEGORY_IMAGE_URL + widget.category.backgroundImage,
                      ),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: Text(
            widget.category.name.toUpperCase(),
            style: TextStyle(
                //backgroundColor: Colors.black.withOpacity(.1),
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
