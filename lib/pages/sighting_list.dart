import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../apis/Sightingsapi.dart';
import '../widgets/MapLegend_widg.dart';

class SightingslistPage extends StatefulWidget {
  SightingslistPage({Key? key}) : super(key: key);

  @override
  State<SightingslistPage> createState() => _SightingslistPageState();
}

class _SightingslistPageState extends State<SightingslistPage> {
  var mapType = MapType.normal;
  var markers = Set<Marker>();
  void askLocationPermission() async {
    await Permission.location.request();
  }

  late GoogleMapController _googleMapController;

  late final currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    askLocationPermission();
  }

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
          actions: [
            IconButton(onPressed: chooseMapType, icon: Icon(Icons.settings))
          ],
          title: const Text('Sightings List')),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Colors.black.withOpacity(.4),
            onPressed: () {
              chooseAnimal();
            },
            child: const Icon(Icons.add_location_alt_outlined),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Colors.black.withOpacity(.4),
            onPressed: () {
              showLegend();
            },
            child: const Icon(Icons.map),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      zoom: 10)));
            },
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
        ),
      ]),
      body: Center(
        child: GoogleMap(
          mapType: mapType,
          compassEnabled: true,
          onTap: addMaker_,
          markers: markers,
          onLongPress: addMaker_,
          mapToolbarEnabled: true,
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

  void addMaker_(LatLng latLng) {
    print(latLng);
    Marker marker = Marker(
        flat: true,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Sighting',
          snippet: 'Sighting',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    setState(() {
      markers.add(marker);
    });
    Sightings.uploadMarker(latLng, context);
  }

  void showLegend() {
    showModalBottomSheet(
        anchorPoint: const Offset(0, 1),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            bottom: false,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Legend',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return LegendWidget();
                    }),
              ],
            ),
          );
        });
  }

  void chooseAnimal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose Animal'),
            content: const Text('Select an animal to add a sighting'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void chooseMapType() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //alert dialog to choose map type
          return AlertDialog(
            title: const Text(
              'Choose Map Type',
              style: TextStyle(color: Colors.blue),
            ),
            content: Center(
              child: Container(
                child: Column(children: [
                  //listview to choose map type
                  ListTile(
                    title: const Text('Normal'),
                    onTap: () {
                      setState(() {
                        mapType = MapType.normal;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('Satellite'),
                    onTap: () {
                      setState(() {
                        mapType = MapType.satellite;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('Hybrid'),
                    onTap: () {
                      setState(() {
                        mapType = MapType.hybrid;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text('Terrain'),
                    onTap: () {
                      setState(() {
                        mapType = MapType.terrain;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ]),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Close', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
