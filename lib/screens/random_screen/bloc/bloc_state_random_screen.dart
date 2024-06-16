import 'package:pokemons/logic/api/models/one_pokemon.dart';

abstract class RandomState {}

class SuccessRandomState extends RandomState {
  final OnePokemon results;

  SuccessRandomState(this.results);
}

class LoadingRandomState extends RandomState {}

class InitialRandomState extends RandomState {}
