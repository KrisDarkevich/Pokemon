import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
import 'package:pokemons/logic/api/repository/repository.dart';

abstract class ApiState {}

class SuccessState extends ApiState {
  final FullInfo fullInfo;

  SuccessState(this.fullInfo);
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

  ApiBloc(this.pokemonRepository) : super(InitialState()) {
    on<GetUrlEvent>(
      (event, emit) async {
        emit(LoadingState());
        _results.clear();
        final result =
            await pokemonRepository.getInfo(event.offset, event.limit);
        _results.addAll(result.pokemonApi.results);

        emit(SuccessState(result));
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
