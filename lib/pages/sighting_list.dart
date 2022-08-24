import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SightingslistPage extends StatefulWidget {
  SightingslistPage({Key? key}) : super(key: key);

  @override
  State<SightingslistPage> createState() => _SightingslistPageState();
}

class _SightingslistPageState extends State<SightingslistPage> {
  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
          title: const Text('Sightings List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
            ),
          );
        },
        child: const Icon(Icons.my_location),
      ),
      body: Center(
        child: GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _googleMapController = controller,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-25.452076, 28.483199),
            zoom: 13,
          ),
        ),
      ),
    );
  }
}
