import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();

  String selectedCurrencyTicker = 'USD';
  String selectedCryptoTicker = 'BTC';
  double exchangeRate = 0.0;
  dynamic exchangeRatesChartData = [ExchangeRatesData(DateTime.now(), 0.0)];

  @override
  void initState() {
    // Получаем данные при загрузке приложения
    Future.delayed(Duration.zero, () async {
      exchangeRatesChartData = await coinData.getExchangeRates(
          currency: selectedCurrencyTicker, crypto: selectedCryptoTicker);
      exchangeRate = exchangeRatesChartData[0].exchangeRate;
      // Как только данные получены, передаем их в функцию обновления UI
      updateUI(exchangeRate);
    });
    super.initState();
  }

  // Функция обновления параметров UI
  void updateUI(double exchangeRateUpdate) {
    setState(() {
      exchangeRate = exchangeRateUpdate;
    });
  }

  Container androidDropdown(Map<String, String> itemsMap) {
    List<DropdownMenuItem<String>> androidDropdownItems = [];
    String selectedTicker = '';

    // Создаем список объетов DropdownMenuItem для выпадающего меню
    for (var currency in itemsMap.entries) {
      var newItem = DropdownMenuItem(
          child: Text('${currency.value} [${currency.key}]'),
          value: currency.key);
      androidDropdownItems.add(newItem);
    }

    // Определение типа переменной выпадающего меню по типу словаря
    switch (itemsMap) {
      case currenciesMap:
        selectedTicker = selectedCurrencyTicker;
        break;
      case cryptoMap:
        selectedTicker = selectedCryptoTicker;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTicker,
          iconSize: 30,
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          dropdownColor: const Color(0xFF0331F4),
          borderRadius: BorderRadius.circular(12),
          items: androidDropdownItems,
          onChanged: (value) => setState(() {
            if (itemsMap == currenciesMap) {
              selectedCurrencyTicker = value!;
            } else if (itemsMap == cryptoMap) {
              selectedCryptoTicker = value!;
            }
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: const Color(0xFF03F4C6),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCryptoTicker = ${exchangeRate.round()} $selectedCurrencyTicker',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ),
          SfCartesianChart(
            title: ChartTitle(
              text: 'Chart for the last 6 months',
              textStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            // Initialize category axis
            primaryXAxis: DateTimeAxis(),
            series: <LineSeries<ExchangeRatesData, DateTime>>[
              LineSeries<ExchangeRatesData, DateTime>(
                  // Bind data source
                  dataSource: exchangeRatesChartData,
                  xValueMapper: (ExchangeRatesData exchangeRate, _) =>
                      exchangeRate.day,
                  yValueMapper: (ExchangeRatesData exchangeRate, _) =>
                      exchangeRate.exchangeRate),
            ],
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                androidDropdown(currenciesMap),
                androidDropdown(cryptoMap),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    exchangeRatesChartData = await coinData.getExchangeRates(
                        currency: selectedCurrencyTicker,
                        crypto: selectedCryptoTicker);
                    exchangeRate = exchangeRatesChartData[0].exchangeRate;
                    updateUI(exchangeRate);
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    primary: const Color(0xFF0331F4),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('REQUEST'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
