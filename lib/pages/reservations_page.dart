import 'package:amss_project/extra/api_calls.dart';
import 'package:amss_project/models/reservation.dart';
import 'package:amss_project/widgets/custom_card.dart';
import 'package:amss_project/widgets/stack_widget.dart';
import 'package:flutter/material.dart';

class ReservationsPage extends StatefulWidget {
  final String uuid;

  ReservationsPage(this.uuid);

  @override
  State<StatefulWidget> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage>{
  List<Reservation> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getReservations(updateReservations, widget.uuid);
  }

  void updateReservations(List<Reservation> reservations) {
    setState(() {
      _reservations = reservations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => StackWidget(
    body: Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: _reservations.map((reservation) => 
          CustomCard(
            color: Colors.blueGrey,
            label: 'Reservación para el ${reservation.date} en la parada ${reservation.stop.name}',
            icon: Icon(Icons.check, color: Colors.white),
          )
        ).toList(),
      )
    ),
    condition: _isLoading
  );
}