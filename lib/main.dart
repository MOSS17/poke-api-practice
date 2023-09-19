import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:pokedex/providers/pokemon_list_provider.dart';
import 'package:pokedex/screens/pokemon_details/pokemon_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';

import 'screens/list_screen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      StateNotifierProvider<PokemonStateNotifierProvider, Pokemon>(
        create: (_) => PokemonStateNotifierProvider(),
      ),
      StateNotifierProvider<PokemonListNotifierProvider, PokemonListItems>(
        create: (_) => PokemonListNotifierProvider(),
      ),
    ], child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ListScreen(),
        '/pokemonDetails': (context) => const PokemonDetailsScreen(),
      },
    );
  }
}
