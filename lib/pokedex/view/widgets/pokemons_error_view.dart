import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/cubit/pokedex_cubit.dart';

class PokemonsErrorView extends StatelessWidget {
  const PokemonsErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Failed to load Pokemons'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<PokedexCubit>().loadPokemons(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
