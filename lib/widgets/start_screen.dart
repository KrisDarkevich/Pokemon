import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/constant/poke_style.dart';
import 'package:pokemons/logic/bloc_locale.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
import 'package:pokemons/logic/api/repository/database.dart';
import 'package:pokemons/logic/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _controller = TextEditingController();
  int index = 0;
  late Future<List<Results>> pokemons;
  late PokeDatabase pokeDatabase;

  @override
  void initState() {
    super.initState();

    pokeDatabase = PokeDatabase.instance;
    pokemons = pokeDatabase.allPokemon();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pokemonList,
          style: PokeStyle.titleName,
        ),
        centerTitle: true,
        backgroundColor: PokeColor.red,
        actions: [
          IconButton(
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
                                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$imageId.png',
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
                        style: index < 20
                            ? PokeStyle.blockedButton
                            : PokeStyle.button,
                        onPressed: () {
                          if (index >= 20) {
                            index -= 20;
                            return context.read<ApiBloc>().add(
                                  GetUrlEvent(index, 20),
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
                          index += 20;

                          return context.read<ApiBloc>().add(
                                GetUrlEvent(index, 20),
                              );
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: PokeColor.darkRed,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
