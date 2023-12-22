import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:pokedex/providers/pokemon_list_provider.dart';
import 'package:pokedex/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final pokemonListNotifierProvider = context.watch<PokemonListNotifierProvider>();
    pokemonListNotifierProvider.getPokemonDetails();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: const Text("Pokedex App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _displayTextInputDialog(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StateNotifierBuilder(
        stateNotifier: pokemonListNotifierProvider,
        builder: (context, state, child) {
          return state.results == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                        pokemonListNotifierProvider.addMorePokemon(state);
                      } else {
                        return false;
                      }
                      return true;
                    },
                    child: ListView.separated(
                        key: const Key("pokemon_list"),
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.results!.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < state.results!.length) {
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/pokemonDetails', arguments: index + 1),
                              child: Container(
                                key: Key("pokemon_$index"),
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "assets/images/pokeball.png",
                                      height: 100,
                                      width: 100,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "#${index + 1}",
                                          style: listTileTextStyle,
                                        ),
                                        Text(
                                          state.results![index]['name'][0].toUpperCase() + state.results![index]['name'].substring(1),
                                          style: listTileTextStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                );
        },
      ),
    );
  }
}

Future<void> _displayTextInputDialog(BuildContext context) async {
  TextEditingController textFieldController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Search pokemon by id'),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: textFieldController,
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            counterText: "Sorry but only pokemon id is supported for now",
            hintText: "Enter pokemon id",
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('SEARCH'),
            onPressed: () {
              String value = textFieldController.text;
              if (int.parse(value) < 898 && int.parse(value) > 0) {
                int id = int.parse(textFieldController.text);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pokemonDetails', arguments: id);
              }
            },
          ),
        ],
      );
    },
  );
}
