import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uber_driver/functions/command_google_app.dart';
import 'package:uber_driver/ui/drop_off.dart';
import 'package:uber_driver/utils/text_utilities.dart';
import "package:stop_watch_timer/stop_watch_timer.dart";

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

Map<String, dynamic> intent = {};
Map<String, dynamic> waypoint = {};
Map<String, dynamic> origin = {};
Map<String, dynamic> destination = {};

class PickUp extends StatefulWidget {
  const PickUp({Key? key, required this.tripID, required this.tripDetails})
      : super(key: key);

  final String tripID;
  final Map<String, dynamic> tripDetails;
  @override
  _PickUpState createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  Future<void> checkLocation() async {
    Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.denied ||
          value == LocationPermission.unableToDetermine ||
          value == LocationPermission.deniedForever) {
        Geolocator.requestPermission().then((permissionResponse) async {
          if (permissionResponse == LocationPermission.whileInUse ||
              permissionResponse == LocationPermission.whileInUse) {
            await Geolocator.getCurrentPosition()
                .then((Position position) async {
              origin["latitude"] = position.latitude;
              origin["longitude"] = position.longitude;
              waypoint["latitude"] =
                  widget.tripDetails["origin"]["location"]["latitude"];
              waypoint["longitude"] =
                  widget.tripDetails["origin"]["location"]["longitude"];
              intent["waypoint"] = waypoint;
              intent["destination"] = destination;
              intent["origin"] = origin;
              MapCommands().commandMap(intent);
              db
                  .collection("requests")
                  .doc(widget.tripID)
                  .update({"status": "confirmed"});
            });
          }
        });
      } else {
        await Geolocator.getCurrentPosition().then((Position position) async {
          origin["latitude"] = position.latitude;
          origin["longitude"] = position.longitude;
          waypoint["latitude"] =
              widget.tripDetails["origin"]["location"]["latitude"];
          waypoint["longitude"] =
              widget.tripDetails["origin"]["location"]["longitude"];
          destination["latitude"] =
              widget.tripDetails["destination"]["location"]["lat"];
          destination["longitude"] =
              widget.tripDetails["destination"]["location"]["lon"];
          intent["waypoint"] = waypoint;
          intent["destination"] = destination;
          intent["origin"] = origin;
          MapCommands().commandMap(intent);

          db
              .collection("requests")
              .doc(widget.tripID)
              .update({"status": "confirmed"});
        });
      }
    });
  }

  Position? driverLocation;
  String distanceString = "";
  String passengerDistanceString = "";
  Future<String> getDistance() async {
    await checkLocation();
    String result = "";
    late StreamSubscription<Position> positionStreamSubscription;
    positionStreamSubscription = Geolocator.getPositionStream().listen((event) {
      Timer(Duration(seconds: 2), () async {
        print("Got location on background: ");
        print(event);
        double distancefromPassenger = Geolocator.distanceBetween(
            event.latitude,
            event.longitude,
            widget.tripDetails["origin"]["location"]["latitude"],
            widget.tripDetails["origin"]["location"]["longitude"]);
        double distancefromDestination = Geolocator.distanceBetween(
            event.latitude,
            event.longitude,
            widget.tripDetails["destination"]["location"]["lat"],
            widget.tripDetails["destination"]["location"]["lon"]);
        result =
            "You are ${distancefromPassenger.toStringAsFixed(2)} meters away from your passenger and ${distancefromDestination.toStringAsFixed(2)} meters away from your destination.";
        passengerDistanceString =
            "${distancefromPassenger.toStringAsFixed(2)} m";
        if (distancefromPassenger < 70) {
          Timer(Duration(milliseconds: 100), () async {
            //wait 10 seconds before getting the location again
            //this is to avoid false-positives and glitches

            double finalDistancefromPassenger = Geolocator.distanceBetween(
                event.latitude,
                event.longitude,
                widget.tripDetails["origin"]["location"]["latitude"],
                widget.tripDetails["origin"]["location"]["longitude"]);
            if (finalDistancefromPassenger < 70) {
              //Means it's a true distance without glitches
              //update this trip's status to picked_up
              await db
                  .collection("requests")
                  .doc(widget.tripID.toString())
                  .update({"status": "picked_up"}).then((value) async {
                await db
                    .collection("requests")
                    .doc(widget.tripID)
                    .update({"date_picked_up": DateTime.now()});
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DropOff(
                        tripID: widget.tripID,
                        tripDetails: widget.tripDetails)));
                positionStreamSubscription.cancel();
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
                    "You're on your way to pick up the passenger. Please be careful while driving and do not look at your phone.",
                    textAlign: TextAlign.center,
                    style: defaultTextStyle.copyWith(
                        color: Colors.green, fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Text(
                    "Navigation mode: Pick up",
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
                      passengerDistanceString,
                      textAlign: TextAlign.center,
                      style: defaultTextStyle.copyWith(
                          color: Colors.black87, fontSize: 24),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "away from your passenger...",
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
