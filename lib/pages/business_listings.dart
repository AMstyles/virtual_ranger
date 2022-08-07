import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';

class BusinessListingsPage extends StatefulWidget {
  BusinessListingsPage({Key? key}) : super(key: key);

  @override
  State<BusinessListingsPage> createState() => _BusinessListingsPageState();
}

class _BusinessListingsPageState extends State<BusinessListingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: Text("BusinessListings"),
      ),
    );
    ;
  }
}
