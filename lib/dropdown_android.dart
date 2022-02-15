// Не используется

import 'package:flutter/material.dart';

class AndroidDropdown extends StatefulWidget {
  AndroidDropdown({
    required this.itemsMap,
    required this.pickerType,
    required this.select,
  });

  final Map<String, String> itemsMap;
  final String pickerType;
  final Function select;

  @override
  _AndroidDropdownState createState() => _AndroidDropdownState();
}

class _AndroidDropdownState extends State<AndroidDropdown> {
  List<DropdownMenuItem<String>> androidDropdownItems() {
    List<DropdownMenuItem<String>> androidDropdownItemsList = [];

    for (var currency in widget.itemsMap.entries) {
      var newItem = DropdownMenuItem(
          child: Text('${currency.value} [${currency.key}]'),
          value: currency.key);
      androidDropdownItemsList.add(newItem);
    }
    return androidDropdownItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.pickerType,
          iconSize: 30,
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          items: androidDropdownItems(),
          onChanged: widget.select(),
        ),
      ),
    );
  }
}
