import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/models/base_experience.dart';
import 'package:pokemons/logic/api/models/full_info.dart';
import 'package:pokemons/logic/api/models/one_pokemon.dart';
import 'package:pokemons/logic/api/models/pokemon_list.dart';
import 'package:pokemons/logic/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_state_start_screen.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_event_start_screen.dart';
import 'package:pokemons/services/connection_service.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final PokemonRepository pokemonRepository;
  final List<OnePokemon> _results = [];
  final PokeDatabase pokeDatabase;

  ApiBloc(
    this.pokemonRepository,
    this.pokeDatabase,
  ) : super(InitialState()) {
    on<GetUrlEvent>(
      (event, emit) async {
        try {
          emit(LoadingState());
          final hasInternet = await ConnectionService().hasInternet();

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
            emit(SuccessState(result));
          } else if (!hasInternet) {
            _results.clear();
            final cachedResults =
                await pokeDatabase.getPokemons(event.offset, event.limit);
            _results.addAll(cachedResults);
            final pokemonApi = PokemonList(cachedResults.length, cachedResults);
            final fullInfo = FullInfo(null, pokemonApi);
            emit(SuccessState(fullInfo));
          } else {
            emit(ErrorState());
          }
        } catch (e) {
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
                BaseExperience(0),
                PokemonList(_results.length, _results),
              ),
            ),
          );
        } else {
          final List<OnePokemon> satisfyingPokemons = [];
          for (var res in _results) {
            if (res.name.contains(event.query)) {
              satisfyingPokemons.add(res);
            }
          }
          emit(
            SuccessState(
              FullInfo(
                BaseExperience(0),
                PokemonList(satisfyingPokemons.length, satisfyingPokemons),
              ),
            ),
          );
        }
      },
    );
  }
}
