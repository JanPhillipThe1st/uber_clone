import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class NetworkUtilTomTom extends NetworkUtil {
  static const String STATUS_OK = "ok";

  @override
  Future<PolylineResult> getRouteBetweenCoordinates(
      String tomtomApiKey,
      PointLatLng origin,
      PointLatLng destination,
      TravelMode travelMode,
      List<PolylineWayPoint> wayPoints,
      bool avoidHighways,
      bool avoidTolls,
      bool avoidFerries,
      bool optimizeWaypoints) async {
    var mode = "";
    mode = travelMode.toString().replaceAll('TravelMode.', '');
    PolylineResult result = PolylineResult();
    var params = {
      "key": tomtomApiKey,
    };
    if (wayPoints.isNotEmpty) {
      List wayPointsArray = [];
      wayPoints.forEach((point) => wayPointsArray.add(point.location));
      var wayPointsString = wayPointsArray.join('|');
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    }
    Uri uri = Uri.https(
        "api.tomtom.com",
        "/routing/1/calculateRoute/${origin.latitude},${origin.longitude}:${destination.latitude},${destination.longitude}/json",
        params);

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      List pointLLs = parsedJson["routes"][0]["legs"][0]["points"];
      List<PointLatLng> polyLinePoints = [];
      pointLLs.forEach((element) {
        polyLinePoints
            .add(PointLatLng(element["latitude"], element["longitude"]));
      });

      result.status = parsedJson["status"];
      if (parsedJson["routes"] != null && parsedJson["routes"].isNotEmpty) {
        print(polyLinePoints);
        result.points = polyLinePoints;
      } else {
        result.errorMessage = parsedJson["error_message"];
      }
    }
    return result;
  }
}
