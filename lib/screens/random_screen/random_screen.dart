import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/constant/poke_image.dart';
import 'package:pokemons/constant/poke_style.dart';
import 'package:pokemons/constant/poke_widgets.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_event_random_screen.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_random_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemons/screens/random_screen/bloc/bloc_state_random_screen.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int maxPokemonId = 1302;
    const int firstPokemonId = 0;
    const int pokemonId = 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.getRandomPokemon,
        ),
        centerTitle: true,
        backgroundColor: PokeColor.red,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: PokeColor.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: PokeColor.greyBlue.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(5, 4),
                  )
                ],
              ),
              child: BlocBuilder<RandomBloc, RandomState>(
                builder: (_, state) {
                  if (state is SuccessRandomState) {
                    final imageId =
                        Uri.parse(state.results.url).pathSegments[pokemonId];

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.results.name,
                            style: PokeStyle.name,
                          ),
                          CachedNetworkImage(
                            imageUrl: PokeImage().getPokemonPicture(imageId),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: PokeColor.darkRed,
                            ),
                            errorWidget: (context, url, error) => const Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: PokeColor.greyRed,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (state is InitialRandomState) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.yourPokemon,
                        style: PokeStyle.name,
                      ),
                    );
                  } else {
                    return const Center(
                      child: PokeWidgets.progressIndicator,
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            FilledButton(
              style: PokeStyle.button,
              onPressed: () {
                context.read<RandomBloc>().add(
                      GetRandomPokeEvent(firstPokemonId, maxPokemonId),
                    );
              },
              child: Text(
                AppLocalizations.of(context)!.getPokemon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
