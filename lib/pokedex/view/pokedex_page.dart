import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/offline_mode_banner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_card/pokemon_card.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemons_error_view.dart';
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
        title: const PokeballImage(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const OfflineModeBanner(),
          Expanded(
            child: BlocBuilder<PokedexCubit, PokedexState>(
              builder: (context, state) {
                if (state.status == PokedexStatus.loading) {
                  return const Center(child: PokeballSpinner());
                }

                if (state.status == PokedexStatus.failure &&
                    state.pokemons.isEmpty) {
                  return const PokemonsErrorView();
                }

                if (state.pokemons.isEmpty &&
                    state.status == PokedexStatus.success) {
                  return const Center(child: Text('No Pokemons found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5 / 3.5,
                  ),
                  itemCount: state.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = state.pokemons[index];
                    return PokemonCard(pokemon: pokemon);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
