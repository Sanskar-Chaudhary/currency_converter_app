import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/currency_service.dart';
import '../widgets/currency_input_field.dart';
import '../widgets/currency_dropdown.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String fromCurrency = 'EUR';
  String toCurrency = 'USD';
  double exchangeRate = 1.0;
  double amount = 1.0;
  double result = 1.0;
  DateTime? lastUpdated;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fetchExchangeRate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchExchangeRate() async {
    if (fromCurrency == toCurrency) {
      setState(() {
        exchangeRate = 1.0;
        result = amount;
      });
    } else {
      double rate = await CurrencyService.getExchangeRate(fromCurrency, toCurrency);
      setState(() {
        exchangeRate = rate;
        lastUpdated = DateTime.now();
        _calculateResult();
      });
    }
  }

  void _calculateResult() {
    setState(() {
      result = amount * exchangeRate;
    });
  }

  void _swapCurrencies() {
    _controller.forward(from: 0.0).then((_) {
      setState(() {
        String temp = fromCurrency;
        fromCurrency = toCurrency;
        toCurrency = temp;
        _fetchExchangeRate();
      });
      _controller.reverse();
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
        title: Text('Currency Converter', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchExchangeRate,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
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
                                  RotationTransition(
                                    turns: _animation,
                                    child: IconButton(
                                      icon: Icon(Icons.swap_horiz, color: Colors.blue, size: 30),
                                      onPressed: _swapCurrencies,
                                    ),
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Exchange Rate: $exchangeRate',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Result: $result',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: lastUpdated != null
                    ? Text(
                  'Last updated: ${_formatDateTime(lastUpdated!)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                )
                    : Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
