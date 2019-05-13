class Seat {
  int id, seatNumber;
  
  Seat({this.id, this.seatNumber});

  static List<Seat> allFromResponse(List response) =>
    response.map((obj) => fromMap(obj)).toList().cast<Seat>();

  static Seat fromMap(Map map) => Seat(
    id: map['id'],
    seatNumber: map['seat_number']
  );
}