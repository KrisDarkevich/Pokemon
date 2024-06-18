import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/constant/poke_image.dart';
import 'package:pokemons/constant/poke_style.dart';
import 'package:pokemons/constant/poke_widgets.dart';
import 'package:pokemons/l10n/bloc/bloc_locale.dart';
import 'package:pokemons/logic/api/models/one_pokemon.dart';
import 'package:pokemons/logic/database.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_start_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_state_start_screen.dart';
import 'package:pokemons/screens/start_screen/bloc/bloc_event_start_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _controller = TextEditingController();
  int index = 0;
  late Future<List<OnePokemon>> pokemons;
  late PokeDatabase pokeDatabase;

  @override
  void initState() {
    super.initState();

    pokeDatabase = PokeDatabase.instance;
    pokemons = pokeDatabase.getPokemonList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    const int offset = 20;
    return Scaffold(
      key: const Key('StartScreen'),
      appBar: AppBar(
        key: const Key('appBar'),
        title: Text(
          AppLocalizations.of(context)!.pokemonList,
          style: PokeStyle.titleName,
        ),
        centerTitle: true,
        backgroundColor: PokeColor.red,
        actions: [
          IconButton(
            key: const Key('iconButtonLocale'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            context
                                .read<LocaleBloc>()
                                .add(ChangeLocaleEvent('en'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          key: const Key('switchToRussian'),
                          title: const Text('Russian'),
                          onTap: () {
                            context
                                .read<LocaleBloc>()
                                .add(ChangeLocaleEvent('ru'));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is SuccessState) {
              return Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      label: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onFieldSubmitted: (query) {
                      context.read<ApiBloc>().add(
                            SearchEvent(query),
                          );
                    },
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 150,
                        ),
                        itemCount: state.fullInfo.pokemonApi.results.length,
                        itemBuilder: (context, index) {
                          final pokemonInfo = (state.fullInfo);
                          final urlImageString =
                              pokemonInfo.pokemonApi.results[index].url;
                          final Uri url = Uri.parse(urlImageString);
                          final imageId = url.pathSegments[3];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: PokeColor.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: PokeColor.greyBlue.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(5, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      pokemonInfo
                                          .pokemonApi.results[index].name,
                                      style: PokeStyle.name,
                                    ),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl:
                                        PokeImage().getPokemonPicture(imageId),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      color: PokeColor.darkRed,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: PokeColor.greyRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        style: index < offset
                            ? PokeStyle.blockedButton
                            : PokeStyle.button,
                        onPressed: () {
                          if (index >= offset) {
                            index -= offset;
                            return context.read<ApiBloc>().add(
                                  GetUrlEvent(index, offset),
                                );
                          }
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(
                        width: 200,
                      ),
                      FilledButton(
                        style: PokeStyle.button,
                        onPressed: () {
                          index += offset;

                          return context.read<ApiBloc>().add(
                                GetUrlEvent(index, offset),
                              );
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is ErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: PokeColor.darkRed,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.networkError,
                      style: PokeStyle.name,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      style: PokeStyle.button,
                      onPressed: () {
                        return context.read<ApiBloc>().add(
                              GetUrlEvent(index, offset),
                            );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.tryAgain,
                      ),
                    ),
                  ],
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
    );
  }
}
