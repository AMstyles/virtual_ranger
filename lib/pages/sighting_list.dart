import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/extensions/colorExtension.dart';
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
  late var legendItems;
  AnimalSight? currentAnimal = null;
  String _mapStyle = '';
  var mapType = MapType.normal;
  var markers = Set<Marker>();
  late Timer _timer;

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
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        markers;
      });
    });
    Future.delayed(Duration(minutes: 1), (() {
      _timer.cancel();
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: Platform.isIOS,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Provider.of<MapsData>(context, listen: false).isFetching
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator.adaptive(),
                )
              : IconButton(
                  onPressed: () async {
                    SnackBar mySnackBar =
                        await Provider.of<MapsData>(context, listen: false)
                            .refreshSites();
                    await putSightings();
                    ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
                  },
                  icon: Icon(Icons.refresh, color: Colors.green))
        ],
        title: Text('Sightings List'),
        leading: Container(
          margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.3),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
        ),
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              buildingsEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              mapType: mapType,
              //onTap: (currentAnimal != null) ? showConfirmDialog : (ar) {},
              onLongPress:
                  (currentAnimal != null) ? showConfirmDialog : (ar) {},
              markers: markers,
              onMapCreated: (controller) async {
                _googleMapController = controller;
                _googleMapController.setMapStyle(
                  _mapStyle,
                );

                await putSightings();
                setTheState();
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(-25.377812607116923, 28.315522686420948),
                zoom: 15,
              ),
            ),
            currentAnimal != null
                ? Positioned(
                    top: 17,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(.7)),
                            child: Text(
                              'where did you see the ${currentAnimal?.name}?',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.7)),
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: currentAnimal != null ? 1 : 0,
                              child: Text(
                                'Hold a Location to drop a pin',
                                style: TextStyle(color: Colors.blueGrey),
                              )),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  /*void addEasyMarker(LatLng latLng) async {
    Marker marker = Marker(
       
        markerId: MarkerId(element.animal_id.toString()),
          position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(await MapMarker.svgToPng(context, )));
    setState(() {
      markers.add(marker);
    });
    for (Marker m in markers) {
      print(m.position);
    }
  }*/

  Future<void> putSightings() async {
    try {
      await putLegend(context);
      var fetchedSites = await Sightings.getSightings();

      setState(() {
        fetchedSites.forEach((element) async {
          print(element.animal_id);

          late final pinLocationIcon;
          pinLocationIcon = await MapMarker.svgToPng(
              context, getColor(element.animal_id.toString()));

          setState(() {
            markers.add(Marker(
              markerId: MarkerId(element.animal_id.toString()),
              position: LatLng(element.latitude, element.longitude),
              icon: BitmapDescriptor.fromBytes(pinLocationIcon),
              infoWindow: InfoWindow(
                title: getName(element.animal_id),
                snippet: readTimeStamp(element.sighting_time),
              ),
            ));
          });
        });
      });
    } catch (e) {
      print('error occured: $e');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Row(
      //   children: [
      //     Icon(
      //       Icons.error,
      //       color: Colors.red,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Text('Error occured, please try again later')
      //   ],
      // )));
    }
  }

  String getName(String id) {
    for (var item in legendItems) {
      if (item.id == id) {
        return item.name;
      }
    }
    return '';
  }

  String getColor(String id) {
    for (var item
        in Provider.of<MapsData>(context, listen: false).legendItems) {
      if (item.id == id) {
        print(item.hexColor);
        return item.hexColor;
      }
    }
    return '#FFF';
  }

  void addMaker_(LatLng latLng, AnimalSight sighting) async {
    final isAdded =
        await Sightings.uploadMarker(latLng, context, currentAnimal!);
    Marker marker = Marker(
      flat: true,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      infoWindow: InfoWindow(
        title: getName(sighting.id),
        snippet: TimeOfDay.now().format(context),
      ),
      icon: BitmapDescriptor.fromBytes(
          await MapMarker.svgToPng(context, sighting.hexColor)),
      //await setCustomMapPin(sighting.id),
    );

    if (isAdded) {
      setState(() {
        markers.add(marker);
      });
    }
    /*setState(() {
      markers.add(marker);
    });*/
    //await Sightings.uploadMarker(latLng, context, currentAnimal!);
    setState(() {
      currentAnimal = null;
    });
  }

  Future<void> putLegend(BuildContext context) async {
    legendItems = await Sightings.getColouredAnimal(context);
  }

  void setTheState() {
    setState(() {});
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
                          'Animal Sighting chart',
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
                title: Text('Animal Sighting chart'),
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
                  //title: Text('Confirm'),
                  content: Text(
                    'Are you sure you want to add this sighting on the selected location?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
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
                      child: Text('Yes'),
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  //title: Text('Confirm'),
                  content: Text(
                    'Are you sure you want to add this sighting on the selected location?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
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
                      child: Text('Yes'),
                    ),
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
                        /*showDialog(
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
                            });*/
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
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    String time =
        '${hour.toString().padLeft(2, '0') + ':' + minute.toString().padLeft(2, '0')}';

    return time;
  }
}
