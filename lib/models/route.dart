import 'dart:convert';
import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/stop.dart';

class RouteModel {
  String name;
  int id;
  List<Bus> buses;
  List<Stop> stops;

  RouteModel({this.name, this.buses, this.stops, this.id});

  static List<RouteModel> allFromResponse(String response) {
    var decodedJson = json.decode(response);
    return decodedJson
      .map((obj) => RouteModel.fromMap(obj))
      .toList()
      .cast<RouteModel>();
  }

  static RouteModel fromMap(Map map) {
    List<Bus> buses = map.containsKey('buses') ? Bus.allFromResponse(map['buses']) : [];
    List<Stop> stops = map.containsKey('stops') ? Stop.allFromResponse(map['stops']) : [];
    return new RouteModel(
      name: map['name'],
      id: map['id'],
      buses: buses,
      stops: stops
    );
  }
}