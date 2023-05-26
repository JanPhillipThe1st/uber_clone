import 'package:flutter/material.dart';

class RouteDetails {
  int lengthInMeters = 0;
  int travelTimeInSeconds = 0;
  int trafficDelayInSeconds = 0;
  int trafficLengthInMeters = 0;
  DateTime departureTime = DateTime.now();
  DateTime arrivalTime = DateTime.now();
  fromJson(Map<String, dynamic> json) {
    this.lengthInMeters = json["lengthInMeters"];
    this.travelTimeInSeconds = json["travelTimeInSeconds"];
    this.trafficDelayInSeconds = json["trafficDelayInSeconds"];
    this.trafficLengthInMeters = json["trafficLengthInMeters"];
    this.departureTime = DateTime.parse(json["departureTime"]);
    this.arrivalTime = DateTime.parse(json["arrivalTime"]);
    return this;
  }
}
