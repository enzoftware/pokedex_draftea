import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';

class PokemonEmptyList extends StatelessWidget {
  const PokemonEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const PokeballImage(size: 64),
          const SizedBox(height: 24),
          Text(
            'No Pokemons found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
