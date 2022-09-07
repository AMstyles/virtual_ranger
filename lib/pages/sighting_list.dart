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
  late BitmapDescriptor pinLocationIcon;
  var markers = Set<Marker>();

  late List<Sighting> fetchedSites;

  void putSightings() async {
    fetchedSites = await Sightings.getSightings();
    setState(() {
      fetchedSites.forEach((element) {
        print(element.animal_id);

        setCustomMapPin(element.animal_id.toString());

        markers.add(Marker(
          markerId: MarkerId(element.animal_id.toString()),
          position: LatLng(element.latitude, element.longitude),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(
            title: getName(element.animal_id),
            snippet:
                readTimeStamp(element.sighting_time), //element.sighting_time,
          ),
        ));
      });
    });
  }

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
    //putSightings();
    //setCustomMapPin("20");

    // pinLocationIcon =
    //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  }

  void setCustomMapPin(id) async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/icons/location' + id + '.png');
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed:
                  Provider.of<Anime>(context, listen: false).handleDrawer,
            ),
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0),
                ),
                child: IconButton(
                    onPressed: chooseMapType, icon: Icon(Icons.settings)))
          ],
          title: const Text('Sightings List')),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            elevation: 0,
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
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(.4),
            onPressed: () {
              showLegend();
            },
            child: const Icon(Icons.map),
          ),
        ),
        //Location Button
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(.4),
            onPressed: () {},
            child: const Icon(Icons.my_location),
          ),
        ),*/
      ]),
      body: Container(
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          mapType: mapType,
          onTap: (currentAnimal != null) ? showConfirmDialog : (ar) {},
          markers: markers,
          onMapCreated: (controller) {
            _googleMapController = controller;
            putSightings();
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(-25.453076, 28.483199),
            zoom: 13,
          ),
        ),
      ),
    );
  }

  void putLegend() async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  Marker putMarkerNow(Sighting sighting) {
    return Marker(
      markerId: MarkerId(sighting.animal_id.toString() +
          sighting.latitude.toString() +
          sighting.longitude.toString()),
      position: LatLng(sighting.latitude, sighting.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(0),
      infoWindow: InfoWindow(
        title: getName(sighting.animal_id),
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
    Marker marker = Marker(
        flat: true,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: getName(sighting.id),
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

  void showLegend() {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        anchorPoint: const Offset(0, 1),
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
          return Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Select Map Type",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 25),
                        )),
                    ListTile(
                      title: Text('Normal'),
                      onTap: () {
                        setState(() {
                          mapType = MapType.normal;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Satellite'),
                      onTap: () {
                        setState(() {
                          mapType = MapType.satellite;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Terrain'),
                      onTap: () {
                        setState(() {
                          mapType = MapType.terrain;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Hybrid'),
                      onTap: () {
                        setState(() {
                          mapType = MapType.hybrid;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
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

  String readTimeStamp(String timeStamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp) * 1000);
    String time = '${dateTime.hour}:${dateTime.minute}';
    return time;
  }
}
