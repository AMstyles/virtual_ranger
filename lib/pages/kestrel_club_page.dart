import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/qrscanner_page.dart';
import '../models/constants.dart';
import '../widgets/drawerWidgets/kestrelBird.dart';
import 'Custom/AnimeVals.dart';

class Kestrel_club_page extends StatefulWidget {
  Kestrel_club_page({Key? key}) : super(key: key);

  @override
  State<Kestrel_club_page> createState() => _Kestrel_club_pageState();
}

class _Kestrel_club_pageState extends State<Kestrel_club_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: Image.asset(
          'lib/assets/kestrel_club_logo.png',
          height: 50,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          KestrelBirds(),
          _buildSignUpButton(
            context,
            "SCAN QR CODE",
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
