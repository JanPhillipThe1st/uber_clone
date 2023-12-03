import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreMethods {
  final db = FirebaseFirestore.instance;

  Future<void> deletePassengers() async {
    await db.collection('passengers').get().then((snapshot) async {
      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
      ;
    });
    ;
  }

  Future<void> addSignup(Map<String, dynamic> data) async {
    await db.collection("registrations").add({
      "name": data["name"],
      "username": data["username"],
      "password": data["password"],
      "purok": data["purok"],
      "status": data["status"],
      "barangay": data["barangay"],
      "profile_image": data["profile_picture_image"],
      "email": data["email"],
      "valid_id_image": data["valid_id_image"],
      "user_type": "driver",
      "date_applied": DateTime.now(),
      "drivers_license_image": data["drivers_license_image"],
    });
  }

  Future<List<Map<String, dynamic>>> getRideRequests() async {
    List<Map<String, dynamic>> requests = [];
    QuerySnapshot<Map<String, dynamic>> results = await db
        .collection("requests")
        .where("status", isEqualTo: "open")
        .get();
    results.docs.forEach((result) {
      Map<String, dynamic> map = {};
      map["data"] = result.data();
      map["id"] = result.id;
      requests.add(map);
    });
    return requests;
  }

  Future<Map<String, dynamic>> login(
      {String? username, String? password}) async {
    Map<String, dynamic> result = {};
    await db
        .collection("users")
        .where(Filter.and(
            Filter("username", isEqualTo: username!),
            Filter("password", isEqualTo: password!),
            Filter("user_type", isEqualTo: "driver")))
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        result = value.docs[0].data();
      }
    });
    return result;
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
    return results;
  }
}
