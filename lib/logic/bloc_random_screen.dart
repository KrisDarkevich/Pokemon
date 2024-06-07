import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
import 'package:pokemons/logic/api/repository/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';

abstract class RandomState {}

class SuccessRandomState extends RandomState {
  final Results results;

  SuccessRandomState(this.results);
}

class LoadingRandomState extends RandomState {}

class InitialRandomState extends RandomState {}

abstract class RandomEvent {}

class GetRandomPokeEvent extends RandomEvent {
  final int offset;
  final int limit;

  GetRandomPokeEvent(this.offset, this.limit);
}

class RandomBloc extends Bloc<RandomEvent, RandomState> {
  final PokemonRepository pokemonRepository;
  final PokeDatabase _pokeDatabase;

  RandomBloc(this.pokemonRepository, this._pokeDatabase)
      : super(InitialRandomState()) {
    on<GetRandomPokeEvent>(
      (event, emit) async {
        final connectivityResult = await Connectivity().checkConnectivity();
        bool hasInternet = connectivityResult != ConnectivityResult.none;
        Random randomClass = Random();

        emit(LoadingRandomState());

        if (hasInternet) {
          final result =
              await pokemonRepository.getInfo(event.offset, event.limit);
          int random = randomClass.nextInt(1302);
          final res = result.pokemonApi.results[random];

          emit(SuccessRandomState(res));
        } else if (!hasInternet) {
          final cachedResults =
              await _pokeDatabase.getPokemons(event.offset, event.limit);
          int random = randomClass.nextInt(cachedResults.length);
          final res = cachedResults[random];
          emit(SuccessRandomState(res));
        } else {
          emit(LoadingRandomState());
        }
      },
    );
  }
}
