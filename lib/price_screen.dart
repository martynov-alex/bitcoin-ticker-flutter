import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  int selectedValue = 0;

  Container androidDropdown() {
    List<DropdownMenuItem<String>> androidDropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      androidDropdownItems.add(newItem);
    }
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCurrency,
          iconSize: 20,
          icon: const Icon(
            Icons.arrow_downward_rounded,
            color: Colors.white,
          ),
          // elevation: 16,
          isExpanded: true,
          style: const TextStyle(color: Colors.white),
          items: androidDropdownItems,
          // Ниже более простое решение в соотвествии с документацией
          // на DropdownButton class
          // items: currenciesList
          //     .map((String item) => DropdownMenuItem(
          //           value: item,
          //           child: Text(item),
          //         ))
          //     .toList(),
          onChanged: (value) => setState(() => selectedCurrency = value!),
        ),
      ),
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> iOSPickerItems = [];

    for (String item in currenciesList) {
      iOSPickerItems
          .add(Text(item, style: TextStyle(color: Colors.white, fontSize: 26)));
    }

    return CupertinoPicker(
      squeeze: 1.3,
      useMagnifier: true,
      magnification: 1.1,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedValue = selectedIndex;
        //print(currenciesList[selectedValue]);
      },
      children: iOSPickerItems,
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
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
