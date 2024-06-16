import 'package:pokemons/logic/api/models/one_pokemon.dart';

class PokemonList {
  final int count;
  final List<OnePokemon> results;

  PokemonList(
    this.count,
    this.results,
  );

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    return PokemonList(
      json['count'] as int,
      List<OnePokemon>.from(
        json['results'].map(
          (e) => OnePokemon.fromJson(e),
        ),
      ),
    );
  }
}



