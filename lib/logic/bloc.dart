import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/repository/repository.dart';

abstract class ApiState {}

class SuccessState extends ApiState {
  final FullInfo fullInfo;

  SuccessState(this.fullInfo);
}

class ErrorState extends ApiState {}

class InitialState extends ApiState {}

abstract class ApiEvent {}

class GetUrlEvent extends ApiEvent {}

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final PokemonRepository pokemonRepository;

  ApiBloc(this.pokemonRepository) : super(InitialState()) {
    on<GetUrlEvent>(
      (event, emit) async {
        final result = await pokemonRepository.getInfo();

        emit(SuccessState(result));
      },
    );
  }
}
