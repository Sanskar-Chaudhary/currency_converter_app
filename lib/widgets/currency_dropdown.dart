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
          child: Row(
            children: [
              _getCurrencyIcon(value),
              SizedBox(width: 8),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _getCurrencyIcon(String currency) {
    switch (currency) {
      case 'EUR':
        return Icon(Icons.euro, color: Colors.blue);
      case 'USD':
        return Icon(Icons.attach_money, color: Colors.green);
      case 'INR':
        return Icon(Icons.currency_rupee, color: Colors.deepOrange);
      default:
        return Icon(Icons.money, color: Colors.grey);
    }
  }
}
