import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/currency_service.dart';
import '../widgets/currency_input_field.dart';
import '../widgets/currency_dropdown.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromCurrency = 'EUR';
  String toCurrency = 'USD';
  double exchangeRate = 0.0;
  double amount = 1.0;
  double result = 0.0;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
  }

  Future<void> _fetchExchangeRate() async {
    double rate =
        await CurrencyService.getExchangeRate(fromCurrency, toCurrency);
    setState(() {
      exchangeRate = rate;
      lastUpdated = DateTime.now();
      _calculateResult();
    });
  }

  void _calculateResult() {
    setState(() {
      result = amount * exchangeRate;
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _fetchExchangeRate();
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d-M-y HH:mm:ss');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchExchangeRate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CurrencyInputField(
              label: 'Amount',
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                  _calculateResult();
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrencyDropdown(
                  value: fromCurrency,
                  onChanged: (value) {
                    setState(() {
                      fromCurrency = value!;
                      _fetchExchangeRate();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _swapCurrencies,
                ),
                CurrencyDropdown(
                  value: toCurrency,
                  onChanged: (value) {
                    setState(() {
                      toCurrency = value!;
                      _fetchExchangeRate();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Exchange Rate: $exchangeRate',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            lastUpdated != null
                ? Text('Last updated: ${_formatDateTime(lastUpdated!)}')
                : Container(),
          ],
        ),
      ),
    );
  }
}
