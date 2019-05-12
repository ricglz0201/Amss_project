import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget{
  final String label;
  final Color color;
  final Icon icon;

  CustomCard({this.label, this.color, this.icon});

  @override
  Widget build(BuildContext context) => new Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: color),
      child: makeListTile(),
    ),
  );

  ListTile makeListTile() => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: icon,
    ),
    title: Text(
      label,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    )
  );
}