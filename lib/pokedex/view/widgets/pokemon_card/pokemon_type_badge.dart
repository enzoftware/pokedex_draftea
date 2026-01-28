import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/utils/pokemon_type_colors.dart';

class PokemonTypeBadge extends StatelessWidget {
  const PokemonTypeBadge({
    required this.type,
    super.key,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
