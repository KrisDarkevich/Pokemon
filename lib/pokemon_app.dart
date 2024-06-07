import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/logic/api/repository/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/logic/bloc.dart';
import 'package:pokemons/logic/bloc_random_screen.dart';
import 'package:pokemons/widgets/bottom_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PokemonApp extends StatelessWidget {
  const PokemonApp(
      {super.key, required this.pokemonRepository, required this.pokeDatabase});
  final PokemonRepository pokemonRepository;
  final PokeDatabase pokeDatabase;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ApiBloc>(
            create: (context) => ApiBloc(pokemonRepository, pokeDatabase)
              ..add(GetUrlEvent(0, 20)),
          ),
          BlocProvider<RandomBloc>(
            create: (_) => RandomBloc(pokemonRepository, pokeDatabase),
          ),
        ],
        child: BottomBar(pokemonRepository: pokemonRepository),
      ),
    );
  }
}
