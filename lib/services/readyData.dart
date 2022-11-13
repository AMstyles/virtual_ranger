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

  void refresh() async {
    await getEm();
    notifyListeners();
  }

  Future<SnackBar> refreshSites() async {
    try {
      await getEm();
      notifyListeners();
      return SnackBar(
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
    } catch (e) {
      print(e);
      SnackBar snackBar = SnackBar(
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
            const Text("Error"),
          ],
        ),
      );
      return snackBar;
    }
  }
}
