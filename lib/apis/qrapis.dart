import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:virtual_ranger/models/constants.dart';

import 'package:http/http.dart' as http;

import '../services/page_service.dart';

class QRapi {
  static Future<void> getQR(BuildContext context, String qrData,
      QRViewController qrViewController) async {
    await qrViewController.pauseCamera();
    var url = Uri.parse(QRSubmit_URL);
    //show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    var response = await http.post(url, body: {
      'qr_data': qrData,
      'user_id': Provider.of<UserProvider>(context, listen: false).user!.id,
    });

    //close loading dialog
    Navigator.of(context).pop();

    var responseJson = json.decode(response.body);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: responseJson['success']
                  ? Text(
                      'Success',
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      'Error',
                      style: TextStyle(color: Colors.red),
                    ),
              content: Text(responseJson['data']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    qrViewController.resumeCamera();
                  },
                  child: Text('OK'),
                ),
              ],
            ));
  }
}
