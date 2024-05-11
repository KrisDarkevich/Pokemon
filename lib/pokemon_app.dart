import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/logic/bloc.dart';
import 'package:pokemons/logic/bloc_random_screen.dart';
import 'package:pokemons/widgets/bottom_bar.dart';

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key, required this.pokemonRepository});
  final PokemonRepository pokemonRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ApiBloc>(
            create: (context) =>
                ApiBloc(pokemonRepository)..add(GetUrlEvent(0, 20)),
          ),
          BlocProvider<RandomBloc>(
            create: (_) => RandomBloc(pokemonRepository),
          ),
        ],
        child: BottomBar(pokemonRepository: pokemonRepository),
      ),
    );
  }
}
