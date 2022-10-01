import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/animalforSIGHT.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../apis/Sightingsapi.dart';
import '../services/readyData.dart';
import '../widgets/MapLegend_widg.dart';
import 'package:flutter/services.dart' show rootBundle;

class SightingslistPage extends StatefulWidget {
  SightingslistPage({Key? key}) : super(key: key);

  @override
  State<SightingslistPage> createState() => _SightingslistPageState();
}

class _SightingslistPageState extends State<SightingslistPage> {
  late final legendItems;

  AnimalSight? currentAnimal = null;
  String _mapStyle = '';
  var mapType = MapType.normal;
  var markers = Set<Marker>();

  void askLocationPermission() async {
    await Permission.location.request();
  }

  late GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    askLocationPermission();
    rootBundle.loadString('lib/assets/mapStyle.txt').then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  }

  Future<BitmapDescriptor> setCustomMapPin(id) {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(10, 10)),
      'lib/icons/location' + id + '.png',
    );
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
      extendBodyBehindAppBar: Platform.isIOS,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: Platform.isAndroid
          ? AppBar(
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
              title: const Text('Sightings List'),
            )
          : AppBar(
              leading: Container(
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.3),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed:
                      Provider.of<Anime>(context, listen: false).handleDrawer,
                ),
              ),
              backgroundColor: Colors.transparent,
              //title: const Text('Sightings List'),
              actions: [
                Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.3),
                    ),
                    child: IconButton(
                        onPressed: chooseMapIOS, icon: Icon(Icons.settings)))
              ],
            ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: 'add sight',
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
            heroTag: 'legend',
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(.4),
            onPressed: () {
              showLegend();
            },
            child: const Icon(Icons.map),
          ),
        ),
      ]),
      body: Container(
        child: GoogleMap(
          buildingsEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          mapType: mapType,
          onTap: (currentAnimal != null) ? showConfirmDialog : (ar) {},
          markers: markers,
          onMapCreated: (controller) {
            _googleMapController = controller;
            _googleMapController.setMapStyle(
              _mapStyle,
            );

            putSightings();
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(-25.377812607116923, 28.315522686420948),
            zoom: 15,
          ),
        ),
      ),
    );
  }

  Future<void> putSightings() async {
    await putLegend(context);
    var fetchedSites = await Sightings.getSightings();

    setState(() {
      fetchedSites.forEach((element) async {
        print(element.animal_id);

        late BitmapDescriptor pinLocationIcon;
        pinLocationIcon = await setCustomMapPin(element.animal_id.toString());

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

  String getName(String id) {
    for (var item in legendItems) {
      if (item.id == id) {
        return item.name;
      }
    }
    return '';
  }

  Color getColor(String id) {
    for (var item in currentAnimal =
        Provider.of<MapsData>(context, listen: false).legendItems) {
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
          snippet: TimeOfDay.now().format(context),
        ),
        icon: await setCustomMapPin(sighting.id));

    setState(() {
      markers.add(marker);
    });
    await Sightings.uploadMarker(latLng, context, currentAnimal!);
    setState(() {
      currentAnimal = null;
    });
  }

  Future<void> putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  void showLegend() {
    Platform.isAndroid
        ? showModalBottomSheet(
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
                      itemCount: Provider.of<MapsData>(context, listen: false)
                          .legendItems
                          .length,
                      itemBuilder: (context, index) {
                        return LegendWidget(
                          animalSight: currentAnimal =
                              Provider.of<MapsData>(context, listen: false)
                                  .legendItems[index],
                          callback: () {
                            setCurrentAnimal(index);
                          },
                        );
                      }),
                ],
              );
            })
        : showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                title: Text('Legend'),
                actions: [
                  for (var item in legendItems)
                    CupertinoActionSheetAction(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          CircleAvatar(
                            backgroundColor: item.color,
                            radius: 20,
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          currentAnimal = item;
                        });
                      },
                    )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            });
    ;
  }

  void showConfirmDialog(LatLng latLng) {
    LatLng currPos = latLng;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isAndroid
              ? AlertDialog(
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
                )
              : CupertinoAlertDialog(
                  title: Text('Confirm'),
                  content: Text('Are you sure you want to add this sighting?'),
                  actions: [
                    CupertinoDialogAction(
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
                    CupertinoDialogAction(
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
    Platform.isAndroid
        ? showModalBottomSheet(
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
                          'Choose The Animal',
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
                      itemCount: Provider.of<MapsData>(context, listen: false)
                          .legendItems
                          .length,
                      itemBuilder: (context, index) {
                        return ChooseWidget(
                          animalSight: currentAnimal =
                              Provider.of<MapsData>(context, listen: false)
                                  .legendItems[index],
                          callback: () {
                            setCurrentAnimal(index);
                          },
                        );
                      }),
                ],
              );
            })
        : showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                title: Text('Choose The Animal'),
                actions: [
                  for (var item in legendItems)
                    CupertinoActionSheetAction(
                      child: Text(item.name),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          currentAnimal = item;
                        });
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Info'),
                                content: Text(
                                    'Tap on the map to add the sighting of ${currentAnimal!.name}'),
                                actions: [
                                  CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok'))
                                ],
                              );
                            });
                      },
                    )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            });
  }

  void chooseMapIOS() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text('Choose Map'),
            actions: [
              CupertinoActionSheetAction(
                child: Text('Normal'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    mapType = MapType.normal;
                  });
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Satellite'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    mapType = MapType.hybrid;
                  });
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
      currentAnimal =
          Provider.of<MapsData>(context, listen: false).legendItems[index];
      //print(currentAnimal.name);
    });

    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
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
              )
            : CupertinoAlertDialog(
                title: Text('Add Sighting'),
                content: Text(
                    'Simply tap on the map where you spotted the ${currentAnimal!.name}'),
                actions: [
                  CupertinoDialogAction(
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
