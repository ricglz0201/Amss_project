import 'package:amss_project/pages/reservations_page.dart';
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
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      ProfilePage(widget.user),
      RoutesPage(),
      ReservationPage(widget.user.uuid),
      ReservationsPage(widget.user.uuid),
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
  build(BuildContext context) => Scaffold(
    appBar: _showAppBar(),
    body: _children[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: _showBarItems(),
    ),
  );

  Widget _showAppBar() => AppBar(
    title: Text('El borrego volador'),
    actions: <Widget>[
      FlatButton(
        child: Icon(Icons.exit_to_app, color: Colors.white70),
        onPressed: _signOut
      )
    ],
  );

  List<BottomNavigationBarItem> _showBarItems() => [
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text('Perfil', style: TextStyle(fontSize: 11)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_bus),
      title: Text('Rutas', style: TextStyle(fontSize: 11)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      title: Text('Reservar', style: TextStyle(fontSize: 11)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text('Reservaciones', style: TextStyle(fontSize: 11)),
    )
  ];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}