import 'dart:convert';

import 'package:http/http.dart';
import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/reservation.dart';
import 'package:amss_project/models/route.dart';
import 'package:amss_project/models/stop.dart';

String url = 'https://amss-api.herokuapp.com';

void getRoutes(void Function(List<RouteModel>) doneFunction) async {
  Response response = await get('$url/routes');
  doneFunction(RouteModel.allFromResponse(jsonDecode(response.body)));
}

void getBuses(void Function(List<Bus>) doneFunction, int routeId) async {
  Response response = await get('$url/routes/$routeId/buses');
  doneFunction(Bus.allFromResponse(jsonDecode(response.body)));
}

void getStops(void Function(List<Stop>) doneFunction, int routeId) async {
  Response response = await get('$url/routes/$routeId/stops');
  doneFunction(Stop.allFromResponse(jsonDecode(response.body)));
}

void getReservations(void Function(List<Reservation>) func, String uuid) async {
  Response response = await get('$url/users/$uuid/reservations');
  func(Reservation.allFromResponse(jsonDecode(response.body)));
}

Future<Map> postReservation(Map<String, String> params, String uuid) async {
  Response response = await post('$url/users/$uuid/reservations', body: params);
  return jsonDecode(response.body);
}