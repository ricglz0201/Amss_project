import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/stop.dart';

class RouteModel {
  String name;
  int id;
  List<Bus> buses;
  List<Stop> stops;

  RouteModel({this.name, this.buses, this.stops, this.id});

  static List<RouteModel> allFromResponse(List response) =>
    response.map((obj) => fromMap(obj)).toList().cast<RouteModel>();

  static RouteModel fromMap(Map map) => RouteModel(
    name: map['name'],
    id: map['id'],
    buses: map.containsKey('buses') ? Bus.allFromResponse(map['buses']) : [],
    stops: map.containsKey('stops') ? Stop.allFromResponse(map['stops']) : []
  );
}