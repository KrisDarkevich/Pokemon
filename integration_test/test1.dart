import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokemons/logic/api/api_call.dart';
import 'package:pokemons/logic/api/repository/repository.dart';
import 'package:pokemons/logic/database.dart';
import 'package:pokemons/pokemon_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'end-to-end test',
    () {
      testWidgets(
        'tap on the change language button, change to russian',
        (tester) async {
          final httpClient = HttpClient();
          final api = ApiCall(httpClient);
          final pokemonRepository = PokemonRepository(api);

          final pokeDatabase = PokeDatabase.instance;
          await tester.pumpWidget(
            PokemonApp(
              pokeDatabase: pokeDatabase,
              pokemonRepository: pokemonRepository,
            ),
          );
          final startScreen = find.byKey(const ValueKey('StartScreen'));
          expect(startScreen, findsOneWidget);
          await tester.pump();
          final iconLocale = find.byKey(const ValueKey('iconButtonLocale'));
          expect(iconLocale, findsOneWidget);

          await tester.tap(iconLocale);
          await tester.pump();

          final localization = find.byKey(
            const ValueKey('switchToRussian'),
          );
          expect(localization, findsOneWidget);
          await tester.tap(localization);
          await tester.pump();
          // final appBar = find.byKey(
          //   const ValueKey('appBar'),
          // );

          // final text = find.widgetWithText(AppBar, 'Cписок');
          // expect(text, findsAtLeastNWidgets(1));
          // await tester.pump();
        },
      );
    },
  );
}
