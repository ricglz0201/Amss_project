import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:amss_project/models/route.dart';

class RoutesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  List<RouteModel> routes = [];
  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress()
      ],
    );
  }

  Widget _showBody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: routes.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(routes[index]);
      },
    );
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);
  }

  Card makeCard(RouteModel route) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF1976D2)),
      child: makeListTile(route),
    ),
  );

  ListTile makeListTile(RouteModel route) => ListTile(
    contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: Icon(Icons.map, color: Colors.white),
    ),
    title: Text(
      'Ruta: ' + route.name,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    )
  );

  Future<void> getRoutes() async {
    http.Response response =
      await http.get('http://10.23.9.237:80/routes');
    setState(() {
      routes = RouteModel.allFromResponse(response.body);
      _isLoading = false;
    });
  }
}