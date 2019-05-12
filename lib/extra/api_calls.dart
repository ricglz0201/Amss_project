import 'dart:convert';

import 'package:http/http.dart';
import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/route.dart';
import 'package:amss_project/models/stop.dart';

String url = 'http://10.23.9.237:80';

void getRoutes(void Function(List<RouteModel>) doneFunction) async {
  Response response =
    await get('$url/routes');
  doneFunction(RouteModel.allFromResponse(response.body));
}

void getBuses(void Function(List<Bus>) doneFunction, int routeId) async {
  Response response =
    await get('$url/routes/$routeId/buses');
  doneFunction(Bus.allFromResponse(jsonDecode(response.body)));
}

void getStops(void Function(List<Stop>) doneFunction, int routeId) async {
  Response response =
    await get('$url/routes/$routeId/stops');
  doneFunction(Stop.allFromResponse(jsonDecode(response.body)));
}

Future<Map> postReservation(Map<String, String> params) async {
  Response response =
    await post('$url/users/1/reservations', body: params);
  Map body = jsonDecode(response.body);
  print(body);
  return body;
}