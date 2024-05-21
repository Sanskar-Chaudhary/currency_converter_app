import 'package:flutter/material.dart';

class CurrencyInputField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  CurrencyInputField({required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
