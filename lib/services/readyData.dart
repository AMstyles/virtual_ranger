import 'dart:async';
import 'package:flutter/material.dart';
import '../apis/Sightingsapi.dart';
import '../models/animalforSIGHT.dart';

class MapsData extends ChangeNotifier {
  late var legendItems;
  late Future<List<Sighting>> fetchedSites;
  bool isFetching = false;
  int count = 0;

  Future<List<Sighting>> getEm(BuildContext context) async {
    isFetching = true;
    notifyListeners();

    try {
      this.fetchedSites = Sightings.getSightings(context);
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

  void refresh(context) async {
    await getEm(context);
    notifyListeners();
  }

  Future<SnackBar> refreshSites(context) async {
    SnackBar? mySnackBar;

    try {
      await getEm(context);
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
