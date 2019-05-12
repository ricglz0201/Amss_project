class Stop {
  String name, address;
  int id;

  Stop({this.name, this.address, this.id});

  static List<Stop> allFromResponse(List response) {
    List<Stop> list = response
      .map((obj) => fromMap(obj))
      .toList()
      .cast<Stop>();
    return list;
  }

  static Stop fromMap(Map map) {
    return new Stop(
      id: map['id'],
      name: map['name'],
      address: map['address']
    );
  }
}