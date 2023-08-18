import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreMethods {
  final db = FirebaseFirestore.instance;

  void setDocumentTest(LatLng location) {
    db.collection("passengers").add({
      "name": "User " + location.latitude.toString(),
      "nickname": "Gwapo",
      "location": {"lat": location.latitude, "long": location.longitude},
    });
  }

  Future<void> deletePassengers() async {
    await db.collection('passengers').get().then((snapshot) async {
      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
      ;
    });
    ;
  }

  Future<List<Marker>> getPassengerLocations() async {
    List<Marker> results = [];
    await db.collection("passengers").get().then((value) {
      value.docs.forEach((passengerData) {
        results.add(Marker(
            markerId: MarkerId(passengerData["name"]),
            position: LatLng(passengerData["location"]["lat"],
                passengerData["location"]["long"]),
            draggable: true));
      });
    });
    print(results);
    return results;
  }
}
