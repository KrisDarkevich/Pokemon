import 'package:flutter/material.dart';
import 'package:pokemons/constant/poke_color.dart';

abstract class PokeStyle {
  static const name = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: PokeColor.darkRed,
  );
  static const button = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll<Color>(PokeColor.red),
  );
}
