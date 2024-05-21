import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static Future<double> getExchangeRate(String from, String to) async {
    final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=$from&to=$to'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rates'][to];
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}
