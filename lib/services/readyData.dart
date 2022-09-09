import 'package:flutter/material.dart';
import '../apis/Sightingsapi.dart';
import '../models/animalforSIGHT.dart';

class MapsData extends ChangeNotifier {
  late var legendItems;
  late List<Sighting> fetchedSites;

  Future<void> _getEm() async {
    fetchedSites = await Sightings.getSightings();
    notifyListeners();
  }

  Future<List<Sighting>> getEm() async {
    this.fetchedSites = await Sightings.getSightings();
    notifyListeners();
    return fetchedSites;
  }

  void putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }
}
