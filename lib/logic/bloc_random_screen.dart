import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
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
  

  RandomBloc(this.pokemonRepository) : super(InitialRandomState()) {
    on<GetRandomPokeEvent>(
      (event, emit) async {
        emit(LoadingRandomState());

        final result =
            await pokemonRepository.getInfo(event.offset, event.limit);
        Random randomClass = Random();
        int random = randomClass.nextInt(1302);
        final res = result.pokemonApi.results[random];

        emit(SuccessRandomState(res));
      },
    );
  }
}
