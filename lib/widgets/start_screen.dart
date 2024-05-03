import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/constant/poke_style.dart';
import 'package:pokemons/logic/bloc.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokemon',
          style: TextStyle(
            color: PokeColor.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: PokeColor.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: PokeStyle.button,
                  onPressed: () {},
                  child: const Text('Previous'),
                ),
                const SizedBox(
                  width: 40,
                ),
                FilledButton(
                  style: PokeStyle.button,
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 100,
                ),
                itemCount: 20,
                itemBuilder: (context, index) => _Card(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final int index;
  const _Card(this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
          child: _BlocColumn(
            index: index,
          ),
        ),
      ),
    );
  }
}

class _BlocColumn extends StatelessWidget {
  final int index;
  const _BlocColumn({required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state is SuccessState) {
          final pokemonInfo = (state.fullInfo);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    pokemonInfo.pokemonApi.results[index].name,
                    style: PokeStyle.name,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator(
            color: PokeColor.darkRed,
          );
        }
      },
    );
  }
}
