import 'package:flutter/material.dart';

class PokemonTypeBadge extends StatelessWidget {
  const PokemonTypeBadge({required this.type, super.key});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type[0].toUpperCase() + type.substring(1).toLowerCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
