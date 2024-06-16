import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/l10n/bloc/bloc_locale.dart';
import 'package:pokemons/logic/database.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_start_screen.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_random_screen.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_event_start_screen.dart';
import 'package:pokemons/widgets/bottom_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PokemonApp extends StatelessWidget {
  const PokemonApp({
    super.key,
    required this.pokemonRepository,
    required this.pokeDatabase,
  });
  final PokemonRepository pokemonRepository;
  final PokeDatabase pokeDatabase;

  static const _firstPokemonIndex = 0;
  static const _offsetPokemonIndex = 20;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleBloc(),
      child: BlocBuilder<LocaleBloc, SuccessLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale(state.locale),
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<ApiBloc>(
                  create: (context) => ApiBloc(pokemonRepository, pokeDatabase)
                    ..add(
                      GetUrlEvent(
                        _firstPokemonIndex,
                        _offsetPokemonIndex,
                      ),
                    ),
                ),
                BlocProvider<RandomBloc>(
                  create: (_) => RandomBloc(pokemonRepository, pokeDatabase),
                ),
              ],
              child: BottomBar(pokemonRepository: pokemonRepository),
            ),
          );
        },
      ),
    );
  }
}
