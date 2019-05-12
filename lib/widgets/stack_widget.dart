import 'package:flutter/material.dart';

class StackWidget extends StatelessWidget {
  final Widget body;
  final bool condition;

  StackWidget({this.body, this.condition});

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        body,
        _showCircularProgress()
      ],
    );
  }

  Widget _showCircularProgress(){
    if (condition) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);
  }
}