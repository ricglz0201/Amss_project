import 'package:amss_project/extra/api_calls.dart';
import 'package:amss_project/widgets/custom_card.dart';
import 'package:amss_project/widgets/stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:amss_project/models/route.dart';

class RoutesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  List<RouteModel> routes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRoutes(updateRoutes);
  }

  void updateRoutes(List<RouteModel> response) {
    setState(() {
      routes = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => StackWidget(
    body: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: routes.length,
      itemBuilder: (BuildContext context, int index) {
        return new CustomCard(
          label: 'Ruta: ${routes[index].name}',
          color: Color(0xFF1976D2),
          icon: Icon(Icons.map, color: Colors.white),
        );
      },
    ),
    condition: _isLoading,
  );
}