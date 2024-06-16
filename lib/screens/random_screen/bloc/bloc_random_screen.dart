import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_event_random_screen.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_state_random_screen.dart';
import 'package:pokemons/services/connection_service.dart';

class RandomBloc extends Bloc<RandomEvent, RandomState> {
  final PokemonRepository pokemonRepository;
  final PokeDatabase _pokeDatabase;

  RandomBloc(this.pokemonRepository, this._pokeDatabase)
      : super(InitialRandomState()) {
    on<GetRandomPokeEvent>(
      (event, emit) async {
        final hasInternet = await ConnectionService().hasInternet();

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
