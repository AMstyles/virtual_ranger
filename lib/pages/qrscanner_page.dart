import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:virtual_ranger/apis/permissionsapi.dart';
import 'package:virtual_ranger/apis/qrapis.dart';

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
    super.initState();
    Permissionsapi.askCameraPermission();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
          color: Colors.white,
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off_rounded),
            color: isFlashOn ? Colors.yellow : Colors.white,
            iconSize: 24,
            onPressed: () {
              controller?.toggleFlash();
              setState(() {
                isFlashOn = !isFlashOn;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
          top: false,
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
        padding: EdgeInsets.only(bottom: 30),
        color: Colors.black,
        height: 60,
        child: GestureDetector(
          onTap: (() {
            Navigator.of(context).pop();
          }),
          child: const Center(
            child: Text(
              'Done',
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
      controller.pauseCamera();
      setState(() {
        QRapi.getQR(context, scanData.code ?? '', controller);
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrKey.currentState?.reassemble();
    }
  }
}
