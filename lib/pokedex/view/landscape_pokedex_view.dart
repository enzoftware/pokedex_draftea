import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/cubit/pokedex_cubit.dart';
import 'package:pokedex_draftea/pokedex/cubit/pokedex_state.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/offline_mode_banner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokedex_app_bar.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_card/pokemon_card.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_empty_list.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemons_error_view.dart';

class LandscapePokedexView extends StatelessWidget {
  const LandscapePokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokedexAppBar.landscape(
        onRefresh: () {
          unawaited(context.read<PokedexCubit>().refreshPokemons());
        },
      ),
      body: const SafeArea(
        child: Column(
          children: [
            OfflineModeBanner(),
            Expanded(child: _LandscapePokedexBody()),
          ],
        ),
      ),
    );
  }
}

class _LandscapePokedexBody extends StatelessWidget {
  const _LandscapePokedexBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PokedexCubit, PokedexState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == PokedexStatus.failure &&
          current.pokemons.isEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load pokemons'),
            backgroundColor: Colors.red,
          ),
        );
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.pokemons.length != current.pokemons.length,
      builder: (context, state) {
        if (state.status == PokedexStatus.loading && state.pokemons.isEmpty) {
          return const Center(child: PokeballSpinner());
        }

        if (state.status == PokedexStatus.failure && state.pokemons.isEmpty) {
          return const PokemonsErrorView();
        }

        if (state.pokemons.isEmpty && state.status == PokedexStatus.success) {
          return const PokemonEmptyList();
        }

        final itemCount = state.pokemons.length + 1;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.5 / 3.5,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == state.pokemons.length) {
              return _LoadMoreCard(
                isLoading: state.status == PokedexStatus.loadingMore,
              );
            }
            return PokemonCard(pokemon: state.pokemons[index]);
          },
        );
      },
    );
  }
}

class _LoadMoreCard extends StatelessWidget {
  const _LoadMoreCard({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading
            ? null
            : () => unawaited(context.read<PokedexCubit>().loadPokemons()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const PokeballSpinner()
              else
                const PokeballImage(size: 80),
              const SizedBox(height: 16),
              Text(
                isLoading ? 'Loading...' : 'Load More',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
