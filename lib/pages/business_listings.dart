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
        title: const Text("BusinessListings"),
      ),
      body: ListView(
        children: [
          _buildHeader(context, 'Emerging Contact Numbers'),
          SizedBox(height: 10),
          _buildHeader(context, 'Accomodation'),
          SizedBox(height: 10),
          _buildHeader(context, 'Restaurants'),
          SizedBox(height: 10),
          SizedBox(height: 10),
          _buildHeader(context, 'Services'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
