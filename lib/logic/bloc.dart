import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
import 'package:pokemons/logic/api/repository/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';

abstract class ApiState {}

class SuccessState extends ApiState {
  final FullInfo fullInfo;

  SuccessState(this.fullInfo);
}

class NoInternetSuccessState extends ApiState {
  final List<Results> results;

  NoInternetSuccessState(this.results);
}

class ErrorState extends ApiState {}

class LoadingState extends ApiState {}

class InitialState extends ApiState {}

abstract class ApiEvent {}

class GetUrlEvent extends ApiEvent {
  final int offset;
  final int limit;

  GetUrlEvent(this.offset, this.limit);
}

class SearchEvent extends ApiEvent {
  final String query;

  SearchEvent(this.query);
}

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final PokemonRepository pokemonRepository;
  final List<Results> _results = [];
  final PokeDatabase pokeDatabase;

  ApiBloc(this.pokemonRepository, this.pokeDatabase) : super(InitialState()) {
    on<GetUrlEvent>(
      (event, emit) async {
        emit(LoadingState());
        final connectivityResult = await Connectivity().checkConnectivity();
        bool hasInternet = connectivityResult != ConnectivityResult.none;
        bool noInternet = connectivityResult == ConnectivityResult.none;

        if (hasInternet) {
          _results.clear();
          final result =
              await pokemonRepository.getInfo(event.offset, event.limit);
          _results.addAll(result.pokemonApi.results);
          for (var result in _results) {
            final existingPokemon =
                await pokeDatabase.getPokemonByName(result.name);
            if (existingPokemon == null) {
              await pokeDatabase.insertPokemon(result);
            }
          }
          List<Results> pokemons = await pokeDatabase.getAllPokemons();
          for (var pokemon in pokemons) {}
          emit(SuccessState(result));
        } else if (noInternet) {
          final cachedResults = await pokeDatabase.getAllPokemons();
          _results.addAll(cachedResults);
          emit(
            NoInternetSuccessState(_results),
          );
        } else {
          emit(ErrorState());
        }
      },
    );

    on<SearchEvent>(
      (event, emit) async {
        emit(LoadingState());
        if (event.query.isEmpty) {
          emit(
            SuccessState(
              FullInfo(
                OnePokemon(0),
                PokemonApi(_results.length, _results),
              ),
            ),
          );
        } else {
          final List<Results> satisfyingPokemons = [];
          for (var res in _results) {
            if (res.name.contains(event.query)) {
              satisfyingPokemons.add(res);
            }
          }

          emit(
            SuccessState(
              FullInfo(
                OnePokemon(0),
                PokemonApi(satisfyingPokemons.length, satisfyingPokemons),
              ),
            ),
          );
        }
      },
    );
  }
}
