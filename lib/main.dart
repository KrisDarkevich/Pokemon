import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pokemons/logic/api/api_call.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/pokemon_app.dart';

void main() {
  final api1 = HttpClient();
  final api = ApiCall(api1);
  final api2 = PokemonRepository(api);
  runApp(
    PokemonApp(pokemonRepository: api2),
  );
}
