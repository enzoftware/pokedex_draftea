import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class PokedexPage extends StatelessWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = PokedexCubit(
          repository: context.read<PokemonRepository>(),
        );
        unawaited(cubit.loadPokemons());
        return cubit;
      },
      child: const PokedexView(),
    );
  }
}

class PokedexView extends StatelessWidget {
  const PokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex Draftea'),
        centerTitle: true,
      ),
      body: BlocBuilder<PokedexCubit, PokedexState>(
        builder: (context, state) {
          if (state.status == PokedexStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PokedexStatus.failure && state.pokemons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load Pokemons'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PokedexCubit>().loadPokemons(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.pokemons.isEmpty && state.status == PokedexStatus.success) {
            return const Center(child: Text('No Pokemons found'));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: state.pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = state.pokemons[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      width: 50,
                      height: 50,
                      errorWidget: (_, _, _) => const Icon(Icons.error),
                      progressIndicatorBuilder: (_, _, _) =>
                          const CircularProgressIndicator(),
                    ),
                    title: Text(pokemon.name),
                    subtitle: Text('#${pokemon.id}'),
                  );
                },
              ),
              if (state.status == PokedexStatus.failure)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: const Text(
                      'Offline mode - showing cached data',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
