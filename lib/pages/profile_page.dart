import 'package:flutter/material.dart';
import 'package:amss_project/models/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          _showLogo(),
          Text(
            user.mail,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          _showBody()
        ],
      )
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
        child: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 48.0,
          child: new Icon(Icons.person, size: 40),
        ),
      ),
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, .0, .0),
      child: new Column(
        children: <Widget>[
          Text(
            'Pases',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
          ),
          Padding(padding: EdgeInsets.fromLTRB(.0, .0, .0, 5)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _showTickets(),
          ),
        ],
      ),
    );
  }

  List<Widget> _showTickets() {
    return <Widget>[
      Icon(Icons.payment),
      Icon(Icons.payment),
      Icon(Icons.payment),
    ];
  }
}