import 'package:dio/dio.dart';
import 'package:state_notifier/state_notifier.dart';

class PokemonListNotifierProvider extends StateNotifier<PokemonListItems> {
  PokemonListNotifierProvider() : super(PokemonListItems(count: 0, next: '', previous: null, results: []));
  final PokemonListItems _pokemonDetails = PokemonListItems(count: 0, next: '', results: []);

  Future<void> getPokemonDetails() async {
    state = await _pokemonDetails.getPokemonList();
  }

  Future<void> addMorePokemon(PokemonListItems oldState) async {
    state = await _pokemonDetails.addMorePokemon(oldState);
  }
}

class PokemonListItems {
  late int count;
  late String next;
  late dynamic previous;
  late dynamic results;

  PokemonListItems({required this.count, required this.next, this.previous, required this.results});

  PokemonListItems.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<PokemonListItems> getPokemonList() async {
    final dio = Dio();
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon?limit=20');
      return PokemonListItems(
        count: response.data['count'],
        next: response.data['next'],
        previous: response.data['previous'],
        results: response.data['results'],
      );
    } catch (e) {
      return PokemonListItems(count: 0, next: '', previous: null, results: []);
    }
  }

  Future<PokemonListItems> addMorePokemon(PokemonListItems state) async {
    final dio = Dio();
    try {
      final response = await dio.get(state.next);
      return PokemonListItems(
        count: response.data['count'],
        next: response.data['next'],
        previous: response.data['previous'],
        results: state.results + response.data['results'],
      );
    } catch (e) {
      return PokemonListItems(count: 0, next: '', previous: null, results: []);
    }
  }
}

class Results {
  late String name;
  late String url;

  Results({required this.name, required this.url});

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
