import 'package:flutter/foundation.dart';

class Anime extends ChangeNotifier {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isOpen = false;

  //!methods
  void closeDrawer() {
    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isOpen = !isOpen;
    notifyListeners();
  }

  void openDrawer() {
    xOffset = 330;
    yOffset = 50;
    scaleFactor = 0.9;
    isOpen = !isOpen;
    notifyListeners();
  }

  void handleDrawer() {
    isOpen ? closeDrawer() : openDrawer();
  }
}
