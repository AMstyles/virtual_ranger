import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:virtual_ranger/models/animal_image.dart';
import '../models/Specy.dart';
import '../models/category.dart';
import '../models/constants.dart';
import '../models/subCategory.dart';

class Categoryapi {
  static Future<List<Category_>> getCategories() async {
    final response = await http.get(Uri.parse(CATEGORY_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<Category_> categories = [];
    for (var i = 0; i < finalData.length; i++) {
      categories.add(Category_.fromJson(finalData[i]));
    }
    return categories;
  }
}

class SubCategoryapi {
  static Future<List<SubCategory>> getSubCategories() async {
    final response = await http.get(Uri.parse(SUBCATEGORY_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<SubCategory> subCategories = [];
    for (var i = 0; i < finalData.length; i++) {
      subCategories.add(SubCategory.fromJson(finalData[i]));
    }
    return subCategories;
  }
}

class Specyapi {
  static Future<List<Specy>> getSpecies() async {
    final response = await http.get(Uri.parse(SPECIES_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<Specy> species = [];
    for (var i = 0; i < finalData.length; i++) {
      species.add(Specy.fromJson(finalData[i]));
    }
    return species;
  }
}

class Imageapi {
  static Future<List<SpecyImage>> getImages(Specy specy) async {
    final response = await http.get(Uri.parse(SPECIES_IMAGE_URL));
    final pre_data = jsonDecode(response.body);
    final data = pre_data['data'];
    final List<dynamic> finalData = data;
    List<SpecyImage> species = [];
    for (var i = 0; i < finalData.length; i++) {
      if (SpecyImage.fromJson(finalData[i]).animal_id == specy.id) {
        species.add(SpecyImage.fromJson(finalData[i]));
      }
    }
    return species;
  }
}
