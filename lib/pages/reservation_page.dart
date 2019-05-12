import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/seat.dart';
import 'package:amss_project/models/stop.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:amss_project/extra/api_calls.dart';
import 'package:amss_project/models/route.dart';
import 'package:amss_project/models/user.dart';
import 'package:amss_project/widgets/dropdown_widget.dart';
import 'package:amss_project/widgets/submit_button.dart';

class ReservationPage extends StatefulWidget {
  final User user;
  ReservationPage({this.user});

  @override
  State<StatefulWidget> createState() => new _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formkey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();
  final Container emptyContainer = new Container(height: 0.0, width: 0.0);
  
  int _stopId = 0, _seatId = 0, _routeId = 0;
  List<DropdownMenuItem<int>> routes = [], busesAndSeats = [], stops = [];

  @override
  void initState() {
    super.initState();
    getRoutes(updateRoutes);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProgress(),
      ],
    );
  }

  Widget _showForm() {
    List<Widget> children = routes.isEmpty ? 
      [emptyContainer] : _showBody();
    return new Form(
      key: _formkey,
      autovalidate: true,
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: children,
      ),
    );
  }

  Widget _showCircularProgress(){
    if (anyDropdownEmpty()) {
      return Center(child: CircularProgressIndicator());
    } return emptyContainer;
  }

  List<Widget> _showBody() {
    return <Widget>[
      _showDatePicker(),
      _showRoutes(),
      new DropdownWidget(
        id: _seatId,
        list: busesAndSeats,
        label: 'Autobus - Asiento',
        icon: Icon(Icons.event_seat),
        updateState: updateSeat
      ),
      new DropdownWidget(
        id: _stopId,
        list: stops,
        label: 'Parada',
        icon: Icon(Icons.directions_bus),
        updateState: updateStop
      ),
      new SubmitButton(
        label: 'Reservar',
        function: _validateAndSubmit,
      )
    ];
  }

  Widget _showRoutes() {
    return new DropdownWidget(
      id: _routeId, 
      list: routes,
      label: 'Ruta',
      icon: Icon(Icons.map),
      updateState: updateRoute
    );
  }

  void updateRoute(int newId, FormFieldState<int> state) {
    setState(() {
      _routeId = newId;
      busesAndSeats = [];
      stops = [];
      state.didChange(newId);
    });
    getBuses(updateBuses, _routeId);
    getStops(updateStops, _routeId);
  }

  void updateSeat(int newId, FormFieldState<int> state) {
    setState(() {
      _seatId = newId;
      state.didChange(newId);
    });
  }

  void updateStop(int newId, FormFieldState<int> state) {
    setState(() {
      _stopId = newId;
      state.didChange(newId);
    });
  }

  bool anyDropdownEmpty() {
    return routes.isEmpty || busesAndSeats.isEmpty || stops.isEmpty;
  }

  void _validateAndSubmit() async {}

  Future _chooseDate(BuildContext context, String initialDateString) async {
    DateTime now = new DateTime.now();
    var result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(now.year+1)
    );
    if (result == null) return;
    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      return new DateFormat.yMd().parseStrict(input);
    } catch (e) {
      return null;
    }    
  }

  Widget _showDatePicker() {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new TextFormField(
            decoration: new InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: '¿Para cuál día es la reserva?',
              labelText: 'Fecha',
            ),
            controller: _controller,
            keyboardType: TextInputType.datetime,
          )
        ),
        new IconButton(
          icon: const Icon(Icons.more_horiz),
          tooltip: 'Choose date',
          onPressed: (() {
            _chooseDate(context, _controller.text);
          }),
        )
      ]
    );
  }

  void updateRoutes(List<RouteModel> response) {
    List<DropdownMenuItem> newRoutes = response.map((RouteModel route) {
      return new DropdownMenuItem(
        value: route.id,
        child: Text(route.name),
      );
    }).toList();
    setState(() {
      routes = newRoutes;
      _routeId = newRoutes.first.value;
    });
    getBuses(updateBuses, _routeId);
    getStops(updateStops, _routeId);
  }

  void updateBuses(List<Bus> response) {
    List<DropdownMenuItem<int>> newBuses = List<DropdownMenuItem<int>>();
    response.forEach((Bus bus) {
      bus.seats.forEach((Seat seat){
        newBuses.add(new DropdownMenuItem<int>(
          value: seat.id,
          child: Text('Autbus ${bus.id} - ${seat.seatNumber}'),
        ));
      });
    });
    setState(() {
      busesAndSeats = newBuses;
      _seatId = newBuses.first.value;
    });
  }

  void updateStops(List<Stop> response) {
    List<DropdownMenuItem> newStop = response.map((Stop stop) {
      return new DropdownMenuItem(
        value: stop.id,
        child: Text(stop.name),
      );
    }).toList();
    setState(() {
      stops = newStop;
      _stopId = newStop.first.value;
    });
  }
}