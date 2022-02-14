import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // Создаем объект класса CoinData, он содержит метод, который запрашивает
  // данные по курсу для выбранной пары
  CoinData coinData = CoinData();

  // Стартовый выбор тикеров
  String selectedCurrencyTicker = 'USD';
  String selectedCryptoTicker = 'BTC';

  // Курс обмена
  double exchangeRate = 0.0;

  @override
  void initState() {
    super.initState();
    // Получаем данные при загрузке приложения
    Future.delayed(Duration.zero, () async {
      exchangeRate = await coinData.getExchangeRate(
          currency: selectedCurrencyTicker, crypto: selectedCryptoTicker);

      // Как только данные получены, передаем их в функцию обновления UI
      updateUI(exchangeRate);
    });
  }

  // Функция обновления параметров UI
  void updateUI(
    double exchangeRateUpdate,
  ) {
    setState(() {
      exchangeRate = exchangeRateUpdate;
    });
  }

  Container androidDropdown(Map<String, String> itemsMap, String pickerType) {
    List<DropdownMenuItem<String>> androidDropdownItems = [];
    String selectedTicker = '';

    for (var currency in itemsMap.entries) {
      var newItem = DropdownMenuItem(
          child: Text('${currency.value} [${currency.key}]'),
          value: currency.key);
      androidDropdownItems.add(newItem);
    }

    switch (pickerType) {
      case 'currency':
        selectedTicker = selectedCurrencyTicker;
        break;
      case 'crypto':
        selectedTicker = selectedCryptoTicker;
        break;
    }

    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
          items: androidDropdownItems,
          onChanged: (value) => setState(() {
            if (pickerType == 'currency') {
              selectedCurrencyTicker = value!;
            } else if (pickerType == 'crypto') {
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
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: const Color(0xFF03F4C6),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCryptoTicker = ${exchangeRate.toStringAsFixed(6)} $selectedCurrencyTicker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                androidDropdown(currenciesMap, 'currency'),
                androidDropdown(cryptoMap, 'crypto'),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    exchangeRate = await coinData.getExchangeRate(
                        currency: selectedCurrencyTicker,
                        crypto: selectedCryptoTicker);
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
