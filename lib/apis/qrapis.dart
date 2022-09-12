import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_ranger/pages/kestrel_club_page.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
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
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
    var response = await http.post(url, body: {
      'email': Provider.of<UserProvider>(context).user!.email,
      'qr_data': qrData,
      'user_id': Provider.of<UserProvider>(context).user!.id,
    });

    //close loading dialog
    Navigator.of(context).pop();

    var responseJson = json.decode(response.body);

    await showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
                title: responseJson['success']
                    ? Text(
                        'Success',
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        'Error',
                        style: TextStyle(color: Colors.red),
                      ),
                content: (!responseJson['success'])
                    ? Text(responseJson['data'])
                    : Text('The QR has been scanned successfully'),
                actions: [
                  TextButton(
                    onPressed: responseJson['success']
                        ? () {
                            mainPages.remove(3);
                            mainPages.add(Kestrel_club_page());
                            Navigator.pop(context);
                            qrViewController.resumeCamera();
                          }
                        : () {
                            Navigator.pop(context);
                            qrViewController.resumeCamera();
                          },
                    child: Text('OK'),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: responseJson['success']
                    ? Text(
                        'Success',
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        'Error',
                        style: TextStyle(color: Colors.red),
                      ),
                content: (!responseJson['success'])
                    ? Text(responseJson['data'])
                    : Text('The QR has been scanned successfully'),
                actions: [
                  TextButton(
                    onPressed: responseJson['success']
                        ? () {
                            mainPages.remove(3);
                            mainPages.add(Kestrel_club_page());
                            Navigator.pop(context);
                            qrViewController.resumeCamera();
                          }
                        : () {
                            Navigator.pop(context);
                            qrViewController.resumeCamera();
                          },
                    child: Text('OK'),
                  ),
                ],
              ));

    if (responseJson['success']) {
      //User userToBe = User.fromjson(responseJson['data']);
      Provider.of<UserProvider>(context, listen: false)
          .incrementKestel_points();
      UserData.setUser(Provider.of<UserProvider>(context).user!);
    }
  }
}
