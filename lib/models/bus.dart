import 'package:amss_project/models/seat.dart';

class Bus {
  int bicyclesSlotsAvailable, seatsAvailable, id;
  List<Seat> seats;
  
  Bus({this.id, this.bicyclesSlotsAvailable, this.seatsAvailable, this.seats});

  static List<Bus> allFromResponse(List response) => 
    response.map((obj) => fromMap(obj)).toList().cast<Bus>();

  static Bus fromMap(Map map) => Bus(
    id: map['id'],
    bicyclesSlotsAvailable: map['bycicles_slots_available'],
    seatsAvailable: map['seats_available'],
    seats: Seat.allFromResponse(map['seats'])
  );
}