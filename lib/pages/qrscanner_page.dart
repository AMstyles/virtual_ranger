import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  final qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    askPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: QRView(
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 8,
          cutOutHeight: MediaQuery.of(context).size.width * 0.85,
          cutOutWidth: MediaQuery.of(context).size.width * .85,
        ),
        onQRViewCreated: _onQRViewCreated,
        key: qrKey,
      )),
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(.3),
        height: 60,
        child: GestureDetector(
          onTap: (() {
            Navigator.of(context).pop();
          }),
          child: const Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      debugPrint(scanData.code);
      controller.pauseCamera();
      Navigator.of(context).pop(scanData.code);
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrKey.currentState?.reassemble();
    }
  }

  void askPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return;
    } else if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
