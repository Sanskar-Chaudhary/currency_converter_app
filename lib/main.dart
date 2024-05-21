import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue[800]),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.blue[700]),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          buttonColor: Colors.blue[600],
        ),
      ),
      home: HomeScreen(),
    );
  }
}
