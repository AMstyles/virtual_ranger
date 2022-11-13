import 'package:flutter/material.dart';
import '../apis/Sightingsapi.dart';
import '../models/animalforSIGHT.dart';

class MapsData extends ChangeNotifier {
  late var legendItems;
  late List<Sighting> fetchedSites;
  bool isFetching = false;

  Future<List<Sighting>> getEm() async {
    isFetching = true;
    this.fetchedSites = await Sightings.getSightings();
    isFetching = false;
    notifyListeners();
    return fetchedSites;
  }

  void putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  void refresh() {
    getEm();
    notifyListeners();
  }
}
