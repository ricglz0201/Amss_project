import 'package:flutter/material.dart';
import 'package:amss_project/extra/auth.dart';
import 'package:amss_project/models/user.dart';
import 'package:amss_project/pages/profile_page.dart';
import 'package:amss_project/pages/reservation_page.dart';
import 'package:amss_project/pages/routes_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.user, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final User user;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _children = [
      new ProfilePage(widget.user),
      new RoutesPage(),
      new ReservationPage()
    ];
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('El borrego volador'),
        actions: <Widget>[
          new FlatButton(
              child: new Icon(Icons.exit_to_app, color: Colors.white70),
              onPressed: _signOut
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.directions_bus),
            title: new Text('Available buses'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.book),
            title: new Text('Book'),
          )
        ],
      ),
    );
  }
}