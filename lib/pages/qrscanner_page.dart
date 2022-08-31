import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  QRViewController? _controller;
  final qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildQrView(context)),
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(1),
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

  Widget buildQrView(BuildContext context) {
    return QRView(
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 8,
        cutOutHeight: MediaQuery.of(context).size.height * 0.6,
        cutOutWidth: MediaQuery.of(context).size.width * .6,
      ),
      onQRViewCreated: (QRViewController) {},
      key: qrKey,
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this._controller = controller;
    });
  }
}
