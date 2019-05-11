import 'package:flutter/material.dart';
import 'package:amss_project/models/route.dart';
import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/stop.dart';

class RoutesPage extends StatelessWidget {
  RoutesPage();
  final List<RouteModel> routes = getRoutes();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: routes.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(routes[index]);
      },
    );
  }

  Card makeCard(RouteModel route) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF1976D2)),
      child: makeListTile(route),
    ),
  );

  ListTile makeListTile(RouteModel route) => ListTile(
    contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: Icon(Icons.map, color: Colors.white),
    ),
    title: Text(
      'Ruta: ' + route.name,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    )
  );
}

List<RouteModel> getRoutes() {
  return [
    RouteModel(name: 'Morones Prieto',
               buses: getBuses(),
               stops: getStops()),
    RouteModel(name: 'Garza Sada',
               buses: getBuses(),
               stops: getStops()),
    RouteModel(name: 'Valle Alto',
               buses: getBuses(),
               stops: getStops()),
    RouteModel(name: 'EGADE',
               buses: getBuses(),
               stops: getStops())
  ];
}

List<Bus> getBuses() {
  return [
    Bus(bicyclesSlotsAvailable: 1, seatsAvailable: 10)
  ];
}

List<Stop> getStops() {
  return [
    Stop(name: '1', address: 'somewhere'),
    Stop(name: '1', address: 'somewhere'),
    Stop(name: '1', address: 'somewhere'),
  ];
}