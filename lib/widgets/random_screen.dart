import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemons/constant/poke_color.dart';
import 'package:pokemons/constant/poke_style.dart';
import 'package:pokemons/logic/bloc_random_screen.dart';

// ignore: must_be_immutable
class RandomScreen extends StatelessWidget {
  RandomScreen({super.key});
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get random pokemon'),
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
                        Uri.parse(state.results.url).pathSegments[3];

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.results.name,
                            style: PokeStyle.name,
                          ),
                          Image.network(
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$imageId.png',
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is InitialRandomState) {
                    return const Center(
                      child: Text(
                        'Your pokemon...',
                        style: PokeStyle.name,
                      ),
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
            const SizedBox(
              height: 100,
            ),
            FilledButton(
              style: PokeStyle.button,
              onPressed: () {
                context.read<RandomBloc>().add(
                      GetRandomPokeEvent(0, 1302),
                    );
              },
              child: const Text('Get pokemon!'),
            ),
          ],
        ),
      ),
    );
  }
}



//                           //
//                           // 
//
//                            
//                                         pokemonInfo
//                                             .pokemonApi.results[index].name,
//                                         style: PokeStyle.name,
//                                       ),
//                                     ),
//                                     Image.network(
//                                       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$imageId.png',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                   );
//                 } else {
//                   return const CircularProgressIndicator(
//                     color: PokeColor.darkRed,
//                   );
//                 }
//               },
//             ),
//            