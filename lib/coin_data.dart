import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = '6E802769-3B00-4133-9965-0E0BA9268258';
const coinAPIMapURL = 'https://rest.coinapi.io/v1/exchangerate';
// Пример запроса: https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=6E802769-3B00-4133-9965-0E0BA9268258

const Map<String, String> currenciesMap = {
  'RUB': 'Russian Ruble',
  'USD': 'US Dollar',
  'EUR': 'Euro',
  'GBP': 'British Pound',
  'CAD': 'Canadian Dollar',
  'AUD': 'Australian Dollar',
  'NZD': 'New Zealand Dollar',
  'JPY': 'Japanese Yen',
};

const Map<String, String> cryptoMap = {
  'BTC': 'Bitcoin',
  'ETH': 'Ethereum',
  'SOL': 'Solana',
  'DOGE': 'Dogecoin',
  'SHIB': 'Shiba Inu',
};

class CoinData {
  Future<double> getExchangeRate(
      {required String currency, required String crypto}) async {
    double exchangeRate = 0.0;

    var uri = Uri.parse('$coinAPIMapURL/$crypto/$currency?apikey=$apiKey');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      exchangeRate = jsonDecode(data)['rate'];
      print(exchangeRate);
      return exchangeRate;
    } else {
      print(response.statusCode);
    }
    return 0.0;
  }
}
