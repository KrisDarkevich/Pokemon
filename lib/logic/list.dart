import 'package:flutter/material.dart';

class ListCountries {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems =  [
      const DropdownMenuItem(value: "Ru", child: Text("Русский")),
      const DropdownMenuItem(value: "Eng", child: Text("English")),
    ];
    return menuItems;
  }
}
