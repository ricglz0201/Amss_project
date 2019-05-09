import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/stop.dart';

class RouteModel {
  String name;
  List<Bus> buses;
  List<Stop> stops;

  RouteModel({this.name, this.buses, this.stops});
}