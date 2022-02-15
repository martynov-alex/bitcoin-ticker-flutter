import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = '14EA97E6-F37D-4A3F-AF90-439B5DBC69DE';
const coinAPIMapURL = 'https://rest.coinapi.io/v1/ohlcv/BITSTAMP_SPOT';
// Пример запроса:
// https://rest.coinapi.io/v1/ohlcv/BITSTAMP_SPOT_BTC_USD/latest?period_id=2DAY&limit=10&apikey=14EA97E6-F37D-4A3F-AF90-439B5DBC69DE

const Map<String, String> currenciesMap = {
  'USD': 'US Dollar',
  'EUR': 'Euro',
  'GBP': 'British Pound',
  // Нижние тикеры не поддерживаются, потому что CoinAPI не предоставляет по ним
  // данные в режиме запроса OHLCV latest data, думаю, можно как-то решить или
  // заменить поставщика данных, но сейчас не принципиально
  // 'RUB': 'Russian Ruble',
  // 'CAD': 'Canadian Dollar',
  // 'AUD': 'Australian Dollar',
  // 'NZD': 'New Zealand Dollar',
  // 'JPY': 'Japanese Yen',
};

const Map<String, String> cryptoMap = {
  'BTC': 'Bitcoin',
  'ETH': 'Ethereum',
  // Нижние тикеры не поддерживаются, потому что CoinAPI не предоставляет по ним
  // данные в режиме запроса OHLCV latest data, думаю, можно как-то решить или
  // заменить поставщика данных, но сейчас не принципиально
  // 'SOL': 'Solana',
  // 'DOGE': 'Dogecoin',
  // 'SHIB': 'Shiba Inu',
};

class CoinData {
  Future<List<ExchangeRatesData>> getExchangeRates(
      {required String currency, required String crypto}) async {
    List<ExchangeRatesData> exchangeRatesList = [];

    // url => uri
    // period_id=5DAY&limit=36 - 36 периодов по 5 дней это примерно 6 мес.
    var uri = Uri.parse(
        '${coinAPIMapURL}_${crypto}_$currency/latest?period_id=5DAY&limit=36&apikey=$apiKey');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      // Декодируем JSON
      List<dynamic> decodedData = jsonDecode(data);

      // Создаем список с объектами ExchangeRatesData для графиков и текущих значений
      for (dynamic item in decodedData) {
        exchangeRatesList.add(ExchangeRatesData(
            DateTime.parse(item['time_close']), item['price_close']));
      }
      return exchangeRatesList;
    } else {
      return [ExchangeRatesData(DateTime.now(), 0.0)];
    }
  }
}

// Объекты данного класса необходимы для построения графиков
class ExchangeRatesData {
  ExchangeRatesData(this.day, this.exchangeRate);
  final DateTime day;
  final double exchangeRate;
}
