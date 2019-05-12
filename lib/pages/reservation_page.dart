import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:amss_project/extra/api_calls.dart';
import 'package:amss_project/models/bus.dart';
import 'package:amss_project/models/route.dart';
import 'package:amss_project/models/seat.dart';
import 'package:amss_project/models/stop.dart';
import 'package:amss_project/widgets/dropdown_widget.dart';
import 'package:amss_project/widgets/stack_widget.dart';
import 'package:amss_project/widgets/submit_button.dart';

class ReservationPage extends StatefulWidget {
  final String uuid;
  ReservationPage(this.uuid);

  @override
  State<StatefulWidget> createState() => new _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();
  final Container emptyContainer = new Container(height: 0.0, width: 0.0);
  
  String _errorMessage = "";
  bool _isLoading = false, _isIos;
  BuildContext _context;
  int _stopId = 0, _seatId = 0, _routeId = 0;
  List<DropdownMenuItem<int>> routes = [], busesAndSeats = [], stops = [];

  @override
  void initState() {
    super.initState();
    getRoutes(updateRoutes);
  }

  bool anyDropdownEmpty() {
    return routes.isEmpty || busesAndSeats.isEmpty || stops.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    _context = context;
    List<Widget> children = routes.isEmpty ? 
      [emptyContainer] : _showBody();
    return StackWidget(
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: children,
        ),
      ),
      condition: anyDropdownEmpty() || _isLoading
    );
  }

  bool _validateAndSave() {
    final currentState = _formKey.currentState;
    if (currentState.validate()) {
      currentState.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      Map<String, String> params = {
        'date': _controller.text,
        'user_id': '1',
        'stop_id': _stopId.toString(),
        'seat_id': _seatId.toString()
      };
      int type;
      String title, subtitle;
      try {
        Map response = await postReservation(params, widget.uuid);
        if (response.containsKey('success')) {
          type = RichAlertType.SUCCESS;
          title = 'Éxito';
          subtitle = 'Se realizó la reserva';
        } else {
          print('Error: ${response['error']}');
          type = RichAlertType.ERROR;
          title = 'Error';
          subtitle = response['error'];
        }
      } catch (e) {
        print('Error: $e');
        type = RichAlertType.ERROR;
        title = 'Error';
        subtitle = _isIos ? e.details : e.message;
      }
      setState(() {
        _isLoading = false;
      });
      _showPopup(title, subtitle, type);
    }
  }

  void _showPopup(String title, String subtitle, int type) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: richTitle(title),
          alertSubtitle: richSubtitle(subtitle),
          alertType: type,
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: (){Navigator.pop(context);},
            ),
          ],
        );
      }
    );
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
      ),
      _showErrorMessage()
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

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300
        ),
      );
    }
    return emptyContainer;
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

  Future _chooseDate(BuildContext context, String initialDateString) async {
    DateTime now = new DateTime.now();
    var result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
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

  Widget _showDatePicker() => new Row(
    children: <Widget>[
      new Expanded(
        child: new TextFormField(
          decoration: new InputDecoration(
            icon: const Icon(Icons.calendar_today),
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