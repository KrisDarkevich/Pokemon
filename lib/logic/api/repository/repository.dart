import 'package:pokemons/logic/api/api_call.dart';
import 'package:pokemons/logic/api/models/full_info.dart';

class PokemonRepository {
  final ApiCall apiCall;

  PokemonRepository(this.apiCall);

  Future<FullInfo> getInfo(int offset, int limit) async {
    final pokeList = await apiCall.getPokeList(offset, limit);
    final onePoke = await apiCall.getInfoOfOne();
    return FullInfo(onePoke, pokeList);
  }
}
