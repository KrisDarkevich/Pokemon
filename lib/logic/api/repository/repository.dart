import 'package:pokemons/logic/api/api_call.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';

class PokemonRepository {
  final ApiCall apiCall;

  PokemonRepository(this.apiCall);

  Future<FullInfo> getInfo(int offset, int limit) async {
    final pokeList = await apiCall.getPokeList(offset, limit);
    final onePoke = await apiCall.getInfoOfOne();
    return FullInfo(onePoke, pokeList);
  }
}

class FullInfo {
  final OnePokemon onePokemon;
  final PokemonApi pokemonApi;

  FullInfo(this.onePokemon, this.pokemonApi);
}
