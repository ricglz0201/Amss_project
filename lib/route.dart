import 'package:amss_project/bus.dart';
import 'package:amss_project/stop.dart';

class RouteModel {
  String name;
  List<Bus> buses;
  List<Stop> stops;

  RouteModel({this.name, this.buses, this.stops});
}