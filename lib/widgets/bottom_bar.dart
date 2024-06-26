import 'package:flutter/material.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/screens/random_screen/random_screen.dart';
import 'package:pokemons/screens/start_screen/start_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatefulWidget {
  final PokemonRepository pokemonRepository;

  const BottomBar({super.key, required this.pokemonRepository});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    _index.value = index;
  }

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _index,
      builder: (_, int value, __) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value,
            selectedItemColor: PokeColor.red,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.homeBar,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.question_mark),
                label: AppLocalizations.of(context)!.randomBar,
              ),
            ],
          ),
          body: Center(
            child: const [
              StartScreen(),
              RandomScreen(),
            ].elementAt(value),
          ),
        );
      },
    );
  }
}
