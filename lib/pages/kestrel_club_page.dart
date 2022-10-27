import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/qrscanner_page.dart';
import 'package:virtual_ranger/services/page_service.dart';
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
        title: const Text('Kestrel Club'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Image.asset(
              'lib/assets/kestrel_club_logo.png',
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                  'Collect 12 Kestrel Club points and claim your rewards!\nPlease visit www.virtualranger.co.za for details.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            KestrelBirds(
              count: Provider.of<UserProvider>(context).user!.kestle_points,
            ),
            _buildSignUpButton(
              context,
              "SCAN QR CODE",
            ),
          ],
        ),
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
