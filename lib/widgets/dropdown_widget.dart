import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final int id;
  final String label;
  final Icon icon;
  final List<DropdownMenuItem<int>> list;
  final void Function(int, FormFieldState<int>) updateState;

  DropdownWidget({this.id, this.list, this.updateState, this.label, this.icon});
  
  @override
  State<DropdownWidget> createState() => 
    _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return new FormField<int>(
      builder: (FormFieldState<int> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: widget.icon,
            labelText: widget.label,
          ),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<int>(
              value: widget.id,
              isDense: true,
              onChanged: (int newValue) => widget.updateState(newValue, state),
              items: widget.list,
            ),
          ),
        );
      },
    );
  }
}