import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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

  static Future<List<Category_>> getCategoriesFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/categories.json');
    final data = jsonDecode(await file.readAsString());
    print(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
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

  static Future<List<SubCategory>> getSubCategoriesFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sub_categories.json');
    final data = jsonDecode(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
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

  static Future<List<Specy>> getSpeciesFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/species.json');
    final data = jsonDecode(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
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

  static Future<List<SpecyImage>> getImagesFromLocal() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/images.json');
    final data = jsonDecode(await file.readAsString());
    final data2 = data['data'];
    final List<dynamic> finalData = data2;
    List<SpecyImage> species = [];
    for (var i = 0; i < finalData.length; i++) {
      species.add(SpecyImage.fromJson(finalData[i]));
    }
    return species;
  }
}
