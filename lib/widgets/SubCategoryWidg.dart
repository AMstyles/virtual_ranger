import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/subCategory.dart';
import '../models/constants.dart';
import '../pages/SpeciesPage.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

class SubCategoryWidg extends StatefulWidget {
  SubCategoryWidg({Key? key, required this.subCategory}) : super(key: key);

  SubCategory subCategory;

  @override
  State<SubCategoryWidg> createState() => _SubCategoryWidgState();
}

class _SubCategoryWidgState extends State<SubCategoryWidg> {
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
          return SpeciesPage(subCategory: widget.subCategory);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: Provider.of<UserProvider>(context).isOffLine ?? false
                    ? FileImage(File(
                            '${UserData.path}/images/${widget.subCategory.BackgroundImage}'))
                        as ImageProvider
                    : CachedNetworkImageProvider(SUBCATEGORY_IMAGE_URL +
                        widget.subCategory.BackgroundImage),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: Text(
            widget.subCategory.name,
            style: TextStyle(
                backgroundColor: Colors.black.withOpacity(.1),
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
