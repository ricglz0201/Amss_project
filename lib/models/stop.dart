class Stop {
  String name, address;
  int id;

  Stop({this.name, this.address, this.id});

  static List<Stop> allFromResponse(List response) =>
    response.map((obj) => fromMap(obj)).toList().cast<Stop>();

  static Stop fromMap(Map map) => Stop(
    id: map['id'],
    name: map['name'],
    address: map['address']
  );
}