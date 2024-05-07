import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pokemons/logic/api/pokemon_api.dart';

class ApiCall {
  static const domain = 'https://pokeapi.co/api/v2';
  final HttpClient client;

  ApiCall(this.client);

  Future<PokemonApi> getPokeList(int offset) async {
    final response = await http.get(
      Uri.parse('$domain/pokemon/?offset=$offset'),
    );

    final json = jsonDecode(response.body);
    final info = PokemonApi.fromJson(json);

    return info;
  }

  Future<OnePokemon> getInfoOfOne() async {
    final Uri url = Uri.parse('$domain/pokemon/2/');

    final response = await http.get(url);

    final json = jsonDecode(response.body);
    final info = OnePokemon.fromJson(json);

    return info;
  }

  // Future<Int> getIdNomber() async {
  //   final Uri url = Uri.parse('$domain/pokemon/2/');

  //   final response = await http.get(url);

  //   final json = jsonDecode(response.body);
  //   final info = OnePokemon.fromJson(json);

  //   return info;
  // }
}


    // print(url.pathSegments[3]);
    //  final int index;
    // index = 1;
        //// final Uri url = Uri.parse('$domain/pokemon/34/');

       // // print(url.pathSegments[3]);


// https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png