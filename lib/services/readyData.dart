import 'package:flutter/material.dart';
import '../apis/Sightingsapi.dart';
import '../models/animalforSIGHT.dart';

class MapsData extends ChangeNotifier {
  late final legendItems;
  late List<Sighting> fetchedSites;

  void getEm() async {
    fetchedSites = await Sightings.getSightings();
    notifyListeners();
  }

  void putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }
}
