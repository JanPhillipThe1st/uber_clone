import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_driver/functions/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_driver/networkUtilTomTom.dart';
import 'package:uber_driver/ui/chat_user.dart';

class ViewRideRequests extends StatefulWidget {
  const ViewRideRequests({Key? key}) : super(key: key);

  @override
  _ViewRideRequestsState createState() => _ViewRideRequestsState();
}

class _ViewRideRequestsState extends State<ViewRideRequests> {
  List<Map<String, dynamic>> requests = [];
  List<String> passengerOriginNearby = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fuckingAsyncCalls();
  }

  Future<void> fuckingAsyncCalls() async {
    await FirestoreMethods().getRideRequests().then((value) async {
      requests.clear();
      passengerOriginNearby.clear();
      for (Map<String, dynamic> element in value) {
        passengerOriginNearby
            .add(element["data"]["origin"]["passenger_location"]);
        requests = value;
      }
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      fuckingAsyncCalls();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Requests"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 230, 230, 230)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(passengerOriginNearby == null
                              ? "..."
                              : "Passenger location: " +
                                  passengerOriginNearby[index]),
                        ),
                        Container(
                          child: Text("Going to: " +
                              requests[index]["data"]["destination"]["place"]),
                        ),
                        requests.isNotEmpty
                            ? TextButton(
                                onPressed: () async {
                                  //First check whether the request has already been accepted by the previous driver
                                  await db
                                      .collection("requests")
                                      .doc(requests[index]["id"])
                                      .get()
                                      .then((value) async {
                                    //null check before proceeding with condition
                                    if (value.data() != null) {
                                      //if it's still open
                                      if (value
                                          .data()!["status"]
                                          .toString()
                                          .contains("open")) {
                                        await db
                                            .collection("requests")
                                            .doc(requests[index]["id"])
                                            .update({
                                          "date_negotiated": DateTime.now()
                                        });
                                        await db
                                            .collection("requests")
                                            .doc(requests[index]["id"])
                                            .update({
                                          "status": "negotiating"
                                        }).then((value) async {
                                          fuckingAsyncCalls();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatUser(
                                                          tripID:
                                                              requests[index]
                                                                  ["id"],
                                                          tripDetails:
                                                              requests[index]
                                                                  ["data"])));
                                        });
                                      } else {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                                'Request Unavailable'),
                                            content: const Text(
                                                'Sorry. This ride request is no longer available.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  });
                                },
                                child: Text("Accept"))
                            : CircularProgressIndicator(),
                      ]),
                ),
              )),
        ],
      ),
    );
  }
}
