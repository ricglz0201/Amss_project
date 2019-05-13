import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final int id;
  final String label;
  final Icon icon;
  final List<DropdownMenuItem<int>> list;
  final void Function(int, FormFieldState<int>) updateState;

  DropdownWidget({this.id, this.list, this.updateState, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return FormField<int>(builder: (FormFieldState<int> state) {
      return InputDecorator(
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: id,
            isDense: true,
            onChanged: (int newValue) => updateState(newValue, state),
            items: list,
          ),
        ),
      );
    });
  }
}
