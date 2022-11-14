import 'dart:async';

import 'package:flutter/material.dart';
import '../apis/Sightingsapi.dart';
import '../models/animalforSIGHT.dart';

class MapsData extends ChangeNotifier {
  late var legendItems;
  late List<Sighting> fetchedSites;
  bool isFetching = false;
  int count = 0;

  Future<List<Sighting>> getEm() async {
    isFetching = true;

    try {
      this.fetchedSites = await Sightings.getSightings();
      isFetching = false;
      notifyListeners();
      return fetchedSites;
    } catch (e) {
      notifyListeners();
      isFetching = false;

      isFetching = false;
      throw e;
    }
  }

  void putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  void refresh() async {
    await getEm();
    notifyListeners();
  }

  Future<SnackBar> refreshSites() async {
    SnackBar? mySnackBar;

    try {
      await getEm();
      notifyListeners();
      mySnackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Refreshed"),
          ],
        ),
      );

      return mySnackBar;
    } catch (e) {
      return SnackBar(
          content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          const SizedBox(
            width: 10,
          ),
          Wrap(children: [
            const Text("Internet connection error."),
          ]),
        ],
      ));
    }
  }
}
