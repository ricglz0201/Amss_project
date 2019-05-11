import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
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
  
  int _stopId, _seatId, _routeId;
  List<DropdownMenuItem<int>> routes, busesAndSeats, stops;

  @override
  void initState() {
    _stopId = 0;
    _seatId = 0;
    _routeId = 0;
    routes = getRoutes();
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return new Form(
      key: _formkey,
      autovalidate: true,
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          _showDatePicker(),
          new DropdownWidget(
            id: _routeId, 
            list: routes,
            label: 'Ruta',
            icon: Icon(Icons.map),
            updateState: updateRoute
          ),
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
        ],
      ),
    );
  }

  void updateRoute(int newId, FormFieldState<int> state) {
    setState(() {
      _routeId = newId;
      state.didChange(newId);
    });
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

  List<DropdownMenuItem<int>> getRoutes() {
    return [
      new DropdownMenuItem(
        value: 0,
        child: Text('Morones'), 
      ),
      new DropdownMenuItem(
        value: 1,
        child: Text('Garza Sada'), 
      ),
    ].toList();
  }
}