import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pokemons/logic/api/api_call.dart';
import 'package:pokemons/logic/api/repository/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/pokemon_app.dart';

void main() {
  final httpClient = HttpClient();
  final api = ApiCall(httpClient);
  final pokemonRepository = PokemonRepository(api);

  WidgetsFlutterBinding.ensureInitialized();
  final pokeDatabase = PokeDatabase.instance;
  runApp(
    PokemonApp(
      pokemonRepository: pokemonRepository,
      pokeDatabase: pokeDatabase,
    ),
  );
}
