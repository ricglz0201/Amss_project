import 'package:amss_project/models/stop.dart';

class Reservation {
  int userId, stopId, tripId, id;
  bool bikeSeatReserved;
  String date;
  Stop stop;

  Reservation({
    this.userId,
    this.stopId,
    this.bikeSeatReserved,
    this.tripId,
    this.id,
    this.stop,
    this.date
  });

  static List<Reservation> allFromResponse(List response) =>
    response.map((obj) => fromMap(obj)).toList().cast<Reservation>();

  static Reservation fromMap(Map map) => Reservation(
    id: map['id'],
    userId: map['user_id'],
    stopId: map['stop_id'],
    tripId: map['trip_id'],
    bikeSeatReserved: map['bike_seat_reserved'],
    stop: Stop.fromMap(map['stop'])
  );
}