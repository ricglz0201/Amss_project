import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final int id;
  final String label;
  final Icon icon;
  final List<DropdownMenuItem<int>> list;
  final void Function(int, FormFieldState<int>) updateState;

  DropdownWidget({this.id, this.list, this.updateState, this.label, this.icon});
  
  @override
  State<StatefulWidget> createState() => 
    new _DropdownWidgetState(id: id, list: list);
}

class _DropdownWidgetState extends State<DropdownWidget> {
  int id;
  List<DropdownMenuItem<int>> list;

  _DropdownWidgetState({this.id, this.list});

  @override
  Widget build(BuildContext context) {
    return new FormField<int>(
      builder: (FormFieldState<int> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: widget.icon,
            labelText: widget.label,
          ),
          isEmpty: id == -1,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<int>(
              value: id,
              isDense: true,
              onChanged: (int newValue) => widget.updateState(newValue, state),
              items: list,
            ),
          ),
        );
      },
    );
  }
}