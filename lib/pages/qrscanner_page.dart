import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  QRViewController? controller;
  bool isFlashOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

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
        color: Colors.black,
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
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });

    controller.scannedDataStream.listen((scanData) {
      debugPrint(scanData.code);
      controller.stopCamera();
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

  void _onPermissionSet(PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      controller!.resumeCamera();
    }
  }
}
