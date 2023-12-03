import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uber_driver/functions/command_google_app.dart';
import 'package:uber_driver/utils/text_utilities.dart';
import "package:stop_watch_timer/stop_watch_timer.dart";

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

Map<String, dynamic> intent = {};
Map<String, dynamic> waypoint = {};
Map<String, dynamic> origin = {};
Map<String, dynamic> destination = {};

class DropOff extends StatefulWidget {
  const DropOff({Key? key, required this.tripID, required this.tripDetails})
      : super(key: key);

  final String tripID;
  final Map<String, dynamic> tripDetails;
  @override
  _PickUpState createState() => _PickUpState();
}

class _PickUpState extends State<DropOff> {
  Position? driverLocation;
  double tripDistance = 00;
  double tripPrice = 00;
  String distanceString = "";
  String destinationDistanceString = "";
  Future<String> getDistance() async {
    String result = "";

    setState(() {
      tripDistance = Geolocator.distanceBetween(
          widget.tripDetails["origin"]["location"]["latitude"],
          widget.tripDetails["origin"]["location"]["longitude"],
          widget.tripDetails["destination"]["location"]["lat"],
          widget.tripDetails["destination"]["location"]["lon"]);
      if (tripDistance < 1500) {
        tripPrice = 15;
      } else {
        tripPrice = 15;
        tripPrice += ((tripDistance - 1500) / 500);
      }
    });
    late StreamSubscription<Position> positionStreamSubscription;
    positionStreamSubscription = Geolocator.getPositionStream().listen((event) {
      Timer(Duration(seconds: 2), () async {
        print("Got location on background: ");
        print(event);
        double distancefromDestination = Geolocator.distanceBetween(
            event.latitude,
            event.longitude,
            widget.tripDetails["destination"]["location"]["lat"],
            widget.tripDetails["destination"]["location"]["lon"]);
        destinationDistanceString =
            "${distancefromDestination.toStringAsFixed(2)} m";
        if (distancefromDestination < 70) {
          Timer(Duration(milliseconds: 100), () async {
            //wait 10 seconds before getting the location again
            //this is to avoid false-positives and glitches

            double finalDistancefromDestination = Geolocator.distanceBetween(
                event.latitude,
                event.longitude,
                widget.tripDetails["destination"]["location"]["lat"],
                widget.tripDetails["destination"]["location"]["lon"]);
            if (finalDistancefromDestination < 70) {
              //Means it's a true distance without glitches
              //update this trip's status to picked_up
              await db
                  .collection("requests")
                  .doc(widget.tripID.toString())
                  .update({"status": "completed"}).then((value) async {
                await db
                    .collection("requests")
                    .doc(widget.tripID)
                    .update({"date_completed": DateTime.now()});
                positionStreamSubscription.cancel();
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Trip Success!'),
                      content: const Text(
                        'Congratulations! The trip has been completed!',
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/view_ride_requests"));
                });
              });
            }
          });
        }
        distanceString = result;

        setState(() {});
      });
    });
    return result;
  }

  StopWatchTimer stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  @override
  void initState() {
    getDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Flex(
          direction: Axis.vertical,
          clipBehavior: Clip.hardEdge,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Container(
              width: double.maxFinite,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Trip price: PHP ${tripPrice.toStringAsFixed(2)}",
                    style: defaultTextStyle.copyWith(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Text(
                    "Navigation mode: Drop off",
                    style: defaultTextStyle.copyWith(
                        color: Colors.blueAccent, fontSize: 24),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "You are",
                      textAlign: TextAlign.center,
                      style: defaultTextStyle.copyWith(
                          color: Colors.black87, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      destinationDistanceString,
                      textAlign: TextAlign.center,
                      style: defaultTextStyle.copyWith(
                          color: Colors.blue, fontSize: 24),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "away from your destination",
                      textAlign: TextAlign.center,
                      style: defaultTextStyle.copyWith(
                          color: Colors.black87, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
