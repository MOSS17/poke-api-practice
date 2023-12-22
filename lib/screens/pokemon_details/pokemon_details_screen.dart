import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:pokedex/utils/app_bar.dart';
import 'package:pokedex/utils/functions.dart';
import 'package:pokedex/utils/text_styles.dart';
import 'package:provider/provider.dart';

import '../../providers/pokemon_provider.dart';
import 'pokemon_type_badge.dart';

class PokemonDetailsScreen extends StatelessWidget {
  const PokemonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    final pokemonStateNotifier = context.watch<PokemonStateNotifierProvider>();
    int currentPokemon = args;
    bool isLoading = true;
    final formkey = GlobalKey<FormState>();
    final descriptionEditingController = TextEditingController();

    String pokemonIdString = changeNumberToThreeDigits(currentPokemon);

    pokemonStateNotifier.getPokemonDetails(currentPokemon).then((value) => isLoading = false);
    return StateNotifierBuilder(
        stateNotifier: pokemonStateNotifier,
        builder: (context, state, child) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: transparentAppBar,
              backgroundColor: getBackgroundColor(state.type1),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                                      child: Text(
                                        "About",
                                        style: aboutTitle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Species",
                                          style: aboutLeftContents,
                                        ),
                                        Text(
                                          state.species[0].toUpperCase() + state.species.substring(1).toLowerCase(),
                                          style: aboutRightContents,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Height",
                                          style: aboutLeftContents,
                                        ),
                                        Text(
                                          "${(state.height / 10).toString()} m",
                                          style: aboutRightContents,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Weight",
                                          style: aboutLeftContents,
                                        ),
                                        Text(
                                          "${(state.weight / 10).toString()} kg",
                                          style: aboutRightContents,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 30,
                                    ),
                                    Text(
                                      "Description",
                                      style: aboutLeftContents,
                                    ),
                                    TextFormField(
                                      controller: descriptionEditingController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a description';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Here you can write the pokemon's description when you find it in the wild",
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                      style: aboutRightContents,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (MediaQuery.of(context).viewInsets.bottom == 0)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      child: Text(
                                        state.name[0].toUpperCase() + state.name.substring(1).toLowerCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Text(
                                      "#$pokemonIdString",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    PokemonTypeBadge(
                                      type: state.type1,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    state.type2 != null ? PokemonTypeBadge(type: state.type2!) : Container(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        currentPokemon--;
                                        if (currentPokemon < 1) {
                                          currentPokemon = 898;
                                        }

                                        pokemonIdString = changeNumberToThreeDigits(currentPokemon);
                                        pokemonStateNotifier.getPokemonDetails(currentPokemon);
                                        descriptionEditingController.clear();
                                      },
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: MediaQuery.of(context).size.width * 0.6,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(state.image),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        currentPokemon++;
                                        if (currentPokemon > 898) {
                                          currentPokemon = 1;
                                        }

                                        pokemonIdString = changeNumberToThreeDigits(currentPokemon);
                                        pokemonStateNotifier.getPokemonDetails(currentPokemon);
                                        descriptionEditingController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: getBackgroundColor(state.type1),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _showDialog(context);
                  }
                },
                child: const Icon(Icons.send),
              ));
        });
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Well Done!!"),
        content: const Text("You are awesome!"),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
