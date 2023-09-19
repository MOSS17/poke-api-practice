import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

class PokemonStateNotifierProvider extends StateNotifier<Pokemon> {
  PokemonStateNotifierProvider() : super(const Pokemon(name: 'not found', image: '', type1: '', type2: null, species: '', height: 0, weight: 0));
  final PokemonDetails _pokemonDetails = PokemonDetails();

  Future<void> getPokemonDetails(int pokemonId) async {
    state = await _pokemonDetails.getPokemonDetails(pokemonId.toString());
  }
}

class PokemonDetails {
  Future<Pokemon> getPokemonDetails(String pokemonId) async {
    final dio = Dio();
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonId');
      return Pokemon(
        name: response.data['name'],
        image: response.data['sprites']['other']['official-artwork']['front_default'],
        type1: response.data['types'][0]['type']['name'],
        type2: response.data['types'].length > 1 ? response.data['types'][1]['type']['name'] : null,
        species: response.data['species']['name'],
        height: response.data['height'],
        weight: response.data['weight'],
      );
    } catch (e) {
      return const Pokemon(name: 'Couldn\'t find your pokemon', image: '', type1: '', type2: null, species: '', height: 0, weight: 0);
    }
  }
}

@immutable
class Pokemon {
  const Pokemon({required this.name, required this.image, required this.type1, this.type2, required this.species, required this.height, required this.weight});
  final String name;
  final String image;
  final String type1;
  final String? type2;
  final String species;
  final int height;
  final int weight;
}
