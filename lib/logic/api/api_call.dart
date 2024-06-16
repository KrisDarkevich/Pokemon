import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pokemons/logic/api/models/base_experience.dart';
import 'package:pokemons/logic/api/models/pokemon_list.dart';

class ApiCall {
  static const _domain = 'https://pokeapi.co/api/v2';
  final HttpClient client;

  ApiCall(this.client);

  Future<PokemonList> getPokeList(int offset, int limit) async {
    final response = await http.get(
      Uri.parse('$_domain/pokemon/?offset=$offset&limit=$limit'),
    );

    final json = jsonDecode(response.body);
    final info = PokemonList.fromJson(json);

    return info;
  }

  Future<BaseExperience> getInfoOfOne() async {
    const int testPokemonId = 2;
    final Uri url = Uri.parse('$_domain/pokemon/$testPokemonId/');

    final response = await http.get(url);

    final json = jsonDecode(response.body);
    final info = BaseExperience.fromJson(json);

    return info;
  }
}
