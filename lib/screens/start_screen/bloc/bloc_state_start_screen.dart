import 'package:pokemons/logic/api/models/full_info.dart';
import 'package:pokemons/logic/api/models/one_pokemon.dart';

abstract class ApiState {}

class SuccessState extends ApiState {
  final FullInfo fullInfo;

  SuccessState(this.fullInfo);
}

class NoInternetSuccessState extends ApiState {
  final List<OnePokemon> results;

  NoInternetSuccessState(this.results);
}

class ErrorState extends ApiState {}

class LoadingState extends ApiState {}

class InitialState extends ApiState {}
