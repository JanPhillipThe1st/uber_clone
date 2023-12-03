import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_driver/functions/firestore.dart';
import 'package:uber_driver/models/RouteDetails.dart';
import 'package:uber_driver/networkUtilTomTom.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  NetworkUtil networkUtil = NetworkUtil();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId? selectedPolyline;
  RouteDetails routeDetails = RouteDetails();
  List<String> nearbyPlaces = [];

  NetworkUtilTomTom networkUtilTomTom = NetworkUtilTomTom();
  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.cyan,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int jointTypesIndex = 0;
  List<JointType> jointTypes = <JointType>[
    JointType.mitered,
    JointType.bevel,
    JointType.round
  ];

  // Values when toggling polyline end cap type
  int endCapsIndex = 0;
  List<Cap> endCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline start cap type
  int startCapsIndex = 0;
  List<Cap> startCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];
  Marker marker = Marker(markerId: MarkerId("Driver Location"));
  // Values when toggling polyline pattern
  int patternsIndex = 0;
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[],
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)],
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)],
  ];
  List<Map<String, dynamic>>? nearbyResult;
  //GoogleMapController _mapController;
  List<LatLng> polylineCoordinates = [];
  List<LatLng> passengerLocations = [];
  bool passengerListExpanded = false;
  List<Marker> passengerLocationMarkers = [];
  void getPolyPoints() async {
    List<LatLng> supportingPoints = [];

    if (passengerLocationMarkers.isNotEmpty) {
      passengerLocationMarkers.forEach((element) {
        supportingPoints.add(element.position);
      });
    }
    PolylineResult result;
    if (supportingPoints.isNotEmpty) {
      PolylineResult result =
          await networkUtilTomTom.getRouteBetweenCoordinates(
              "TNrPv6isrGooVIYCXns3WcJRtjhNAZpy",
              PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
              PointLatLng(destination.latitude, destination.longitude),
              TravelMode.walking,
              supportingPoints,
              false,
              false,
              false,
              false);
      if (routeDetails != null) {}
      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        result.points.forEach(
          (PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          ),
        );

        setState(() {});
      }
    }
    routeDetails = networkUtilTomTom.routeDetails;
  }

  LocationData? currentLocation;
  Future<void> getCurrentLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    Location location = Location();
    await location.getLocation().then(
      (location) {
        currentLocation = location;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16.8,
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
            ),
          ),
        );
      },
    );

    location.onLocationChanged.listen(
      (newLoc) {
        // currentLocation = newLoc;
        sourceLocation = LatLng(newLoc.latitude!, newLoc.longitude!);

        marker = Marker(
            markerId: MarkerId("Driver Location"),
            position: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
            infoWindow: InfoWindow(title: "Driver"));
        setState(() {});
      },
    );
  }

  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(7.829661, 123.434101),
    zoom: 20.0,
  );
  static LatLng sourceLocation = LatLng(7.82503, 123.4376);
  static LatLng destination = LatLng(7.82503, 123.436);
  MapType _mapType = MapType.normal;
  Marker destionationMarker = Marker(
    draggable: true,
    markerId: MarkerId("destination"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: destination,
  );
  @override
  void initState() {
    //_mapController.mar();
    getCurrentLocation().then((value) {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
              'lib/assets/driver_icon.png')
          .then((onValue) {
        marker = Marker(
            markerId: MarkerId("Driver Location"),
            icon: onValue,
            position:
                LatLng(sourceLocation.latitude, sourceLocation.longitude));
      });
    });
    getPolyPoints();
    super.initState();
  }

  BitmapDescriptor? myIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.keyboard_arrow_up)),
            Text("You're offline",
                style: TextStyle(
                  fontSize: 30,
                )),
            Container(
                padding: EdgeInsets.only(right: 20), child: Icon(Icons.list)),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _mapType,
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: const Color(0xFF7B61FF),
                width: 6,
              ),
            },
            initialCameraPosition: _cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              //_initCameraPosition();
            },
            markers: {
              ...passengerLocationMarkers,
              Marker(
                markerId: MarkerId("source"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                position: sourceLocation,
                draggable: true,
                onDrag: (value) {
                  getPolyPoints();
                  sourceLocation = value;
                },
              ),
              destionationMarker.copyWith(
                onDragParam: (value) async {
                  nearbyPlaces.clear();
                  getPolyPoints();
                  destination = value;
                  nearbyResult = await networkUtilTomTom.getNearbyPlaces(
                      "TNrPv6isrGooVIYCXns3WcJRtjhNAZpy",
                      PointLatLng(value.latitude, value.longitude));
                  nearbyResult!.forEach((nearbyPlace) {
                    nearbyPlaces.add(nearbyPlace["name"]);
                  });
                  setState(() {});
                },
              ),
              marker
            },
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FunctionalButton(
                      icon: Icons.search,
                      title: "",
                      onPressed: () {},
                    ),
                    PriceWidget(
                      price: "100.00",
                      onPressed: () {},
                    ),
                    ProfileWidget(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/notifications'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              child: Container(
            margin: EdgeInsets.only(bottom: 80),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  TextButton(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 150, 58, 72),
                      child: Text(
                        "DELETE MARKERS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await FirestoreMethods().deletePassengers();
                      passengerLocationMarkers.clear();
                      // List<Marker> markers =
                      //     await FirestoreMethods().getPassengerLocations();

                      // passengerLocationMarkers.addAll(markers);
                      polylineCoordinates.clear();
                      if (passengerLocationMarkers.isNotEmpty) {
                        destination = passengerLocationMarkers.last.position;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Markers deleted successfully.")));
                      setState(() {});
                    },
                  ),
                  ToggleButtons(children: [
                    TextButton(
                      child: Text("Hybrid"),
                      onPressed: () {
                        _mapType = MapType.hybrid;
                        setState(() {});
                      },
                    ),
                    TextButton(
                      child: Text("Normal"),
                      onPressed: () {
                        _mapType = MapType.normal;
                        setState(() {});
                      },
                    ),
                    TextButton(
                      child: Text("Terrain/Satellite"),
                      onPressed: () {
                        _mapType = MapType.hybrid;
                        setState(() {});
                      },
                    )
                  ], isSelected: [
                    false,
                    true,
                    false
                  ]),
                ],
              ),
            ),
          )),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // FunctionalButton(
                    //   icon: Icons.security,
                    //   title: "",
                    //   onPressed: () {},
                    // ),
                    TextButton(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Color.fromARGB(255, 255, 68, 152),
                        child: Text(
                          "MARK",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Marker added successfully.")));
                      },
                    ),
                    TextButton(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.blueAccent,
                        child: Text(
                          "DISPLAY\nPASSENGERS",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        // List<Marker> markers =
                        //     await FirestoreMethods().getPassengerLocations();
                        // passengerLocationMarkers.addAll(markers);
                        polylineCoordinates.clear();
                        destination = passengerLocationMarkers.last.position;
                        setState(() {});
                      },
                    ),
                    TextButton(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Color.fromARGB(255, 75, 150, 58),
                        child: Text(
                          "CALCULATE BEST ROUTE",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        getPolyPoints();

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Route Calculated.")));
                        setState(() {});
                      },
                    ),
                    Container(
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            width: passengerListExpanded ? 200 : 50,
            height: 120,
            child: passengerListExpanded
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)))),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              (routeDetails.lengthInMeters / 1000).toString() +
                                  "km away",
                            ),
                            Container(
                              child: Text("Passenger Ranking"),
                            ),
                            Container(
                              height: 50,
                              width: 130,
                              child: ListView.builder(
                                  itemCount: passengerLocationMarkers.length,
                                  itemBuilder: (context, index) => Container(
                                        decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shadows: [
                                              BoxShadow(
                                                blurRadius: 1,
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(width: .3),
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2),
                                        child: TextButton(
                                          onPressed: () {
                                            // destionationMarker = destionationMarker.copyWith(positionParam: );
                                          },
                                          child: Text(
                                            // nearbyPlaces[index],
                                            passengerLocationMarkers[index]
                                                .position
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        ),
                        IconButton(
                          splashRadius: 100,
                          icon: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {
                            print(passengerListExpanded);
                            if (!passengerListExpanded) {
                              passengerListExpanded = true;
                            } else {
                              passengerListExpanded = false;
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  )
                : IconButton(
                    splashRadius: 400,
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 50,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      print(passengerListExpanded);
                      if (!passengerListExpanded) {
                        passengerListExpanded = true;
                      } else {
                        passengerListExpanded = false;
                      }
                      setState(() {});
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const FunctionalButton(
      {key, required this.title, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Colors.black,
          fillColor: Colors.white,
          elevation: 15.0,
          shape: CircleBorder(),
          child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(
                widget.icon,
                size: 30.0,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final Function() onPressed;

  const ProfileWidget({key, required this.onPressed}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            "assets/images/user_profile.jpg",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class PriceWidget extends StatefulWidget {
  final String price;
  final Function() onPressed;

  const PriceWidget({key, required this.price, required this.onPressed})
      : super(key: key);

  @override
  _PriceWidgetState createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey, blurRadius: 11, offset: Offset(3.0, 4.0))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("\₱ ",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          Text(widget.price,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class GoButton extends StatefulWidget {
  final String title;
  final Function() onPressed;

  const GoButton({key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  _GoButtonState createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 10),
              shape: BoxShape.circle),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
            ),
            child: RawMaterialButton(
              onPressed: widget.onPressed,
              splashColor: Colors.black,
              fillColor: Colors.blue,
              elevation: 15.0,
              shape: CircleBorder(),
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28))),
            ),
          ),
        ),
      ],
    );
  }
}
