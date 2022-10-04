import 'package:permission_handler/permission_handler.dart';

class Permissionsapi {
  static void askPermission() async {
    await Permission.storage.request();
    await Permission.location.request();
    await Permission.camera.request();
  }

  static void askStoragePermission() async {
    await Permission.storage.request();
  }

  static void askLocationPermission() async {
    await Permission.location.request();
  }

  static void askCameraPermission() async {
    await Permission.camera.request();
  }
}
