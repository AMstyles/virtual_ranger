import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/animalforSIGHT.dart';
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
  late final legendItems;
  AnimalSight? currentAnimal = null;
  var mapType = MapType.normal;
  var markers = Set<Marker>();
  void askLocationPermission() async {
    await Permission.location.request();
  }

  late GoogleMapController _googleMapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    askLocationPermission();
    Sightings.getSightings();
    putLegend();
    //putMarkers();
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
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(currentLocation.latitude, currentLocation.longitude),
                  14));
            },
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
        ),*/
      ]),
      body: Center(
        child: GoogleMap(
          mapType: mapType,
          compassEnabled: true,
          onTap: (currentAnimal != null) ? showConfirmDialog : (ar) {},
          markers: markers,
          //onLongPress: addMaker_,
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

  void putLegend() async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  void putMarkers() async {
    final data = await Sightings.getSightings();
    var markers_ = Set<Marker>();

    for (var item in data) {
      markers_.add(putMarkerNow(item));
      print(item.sighting_time);
    }

    setState(() {
      markers = markers_;
    });
  }

  Marker putMarkerNow(Sighting sighting) {
    return Marker(
      markerId: MarkerId(sighting.animal_id),
      position: LatLng(sighting.latitude, sighting.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(0),
      infoWindow: InfoWindow(
        title: sighting.animal_id,
        snippet: sighting.sighting_time.toString(),
      ),
    );
  }

  String getName(String id) {
    for (var item in legendItems) {
      if (item.id == id) {
        return item.name;
      }
    }
    return '';
  }

  Color getColor(String id) {
    for (var item in legendItems) {
      if (item.id == id) {
        return item.color;
      }
    }
    return Colors.black;
  }

  void addMaker_(LatLng latLng, AnimalSight sighting) async {
    bool isTrue = false;

    Marker marker = Marker(
        flat: true,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: getName(sighting.name),
          snippet: TimeOfDay.now().toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    setState(() {
      markers.add(marker);
    });
    await Sightings.uploadMarker(latLng, context, currentAnimal!);
    setState(() {
      currentAnimal = null;
    });
  }

  void addMakerLoc_(LatLng latLng, AnimalSight sighting) async {
    print(latLng.toString());
    Marker marker = Marker(
        flat: true,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: sighting.name,
          snippet: TimeOfDay.now().toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    setState(() {
      markers.add(marker);
      currentAnimal = null;
    });
    Sightings.uploadMarker(latLng, context, currentAnimal!);
  }

  void showLegend() {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        anchorPoint: const Offset(0, 1),
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Legend',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  //close button
                  Container(
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: legendItems.length,
                  itemBuilder: (context, index) {
                    return LegendWidget(
                      animalSight: legendItems[index],
                      callback: () {
                        setCurrentAnimal(index);
                      },
                    );
                  }),
            ],
          );
        });
  }

  void showConfirmDialog(LatLng latLng) {
    LatLng currPos = latLng;

    print(latLng.latitude.toString() + 'latlng');
    print(latLng.longitude.toString() + 'latlng');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text('Are you sure you want to add this sighting?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentAnimal = null;
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    addMaker_(currPos, currentAnimal!);
                  },
                  child: Text('Confirm')),
            ],
          );
        });
    //alert dialog
  }

  void chooseAnimal() {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        anchorPoint: const Offset(0, 1),
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Choose The Animal You spotted',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //close button
                  Container(
                    alignment: Alignment.center,
                    //padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: legendItems.length,
                  itemBuilder: (context, index) {
                    return ChooseWidget(
                      animalSight: legendItems[index],
                      callback: () {
                        setCurrentAnimal(index);
                      },
                    );
                  }),
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

  void setCurrentAnimal(index) {
    setState(() {
      currentAnimal = legendItems[index];
      //print(currentAnimal.name);
    });

    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add Sighting'),
              content: Text(
                  'Simply tap on the map where you spotted the ${currentAnimal!.name}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'))
              ],
            ));
  }
}
