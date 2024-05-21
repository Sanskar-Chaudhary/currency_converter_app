import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> currencies = ['EUR', 'USD', 'INR'];

  CurrencyDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: currencies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
