import 'package:pokemons/logic/api/models/base_experience.dart';
import 'package:pokemons/logic/api/models/pokemon_list.dart';

class FullInfo {
  final BaseExperience? onePokemon;
  final PokemonList pokemonApi;

  FullInfo(this.onePokemon, this.pokemonApi);
}
