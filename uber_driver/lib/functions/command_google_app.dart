import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MapCommands {
  Future<void> commandMap(Map<String, dynamic> intent) async {
    var uri = Uri.parse(
        // "https://maps.googleapis.com/maps/api/directions/json?origin=${intent["origin"]["latitude"]},${intent["origin"]["longitude"]}&destination=${intent["destination"]["latitude"]},${intent["destination"]["longitude"]}&key=AIzaSyD7gjSeyUE7X9j0j_M4Us918wzxrXw9Mk0");
        "https://www.google.com/maps/dir/?api=1&origin=${intent["origin"]["latitude"]},${intent["origin"]["longitude"]}&destination=${intent["destination"]["latitude"]},${intent["destination"]["longitude"]}&waypoints=${intent["waypoint"]["latitude"]},${intent["waypoint"]["longitude"]}&travelmode=driving&dir_action=navigate");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
