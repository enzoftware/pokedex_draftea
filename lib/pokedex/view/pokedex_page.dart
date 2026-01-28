import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokedex_draftea/pokedex/view/landscape_pokedex_view.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/offline_mode_banner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokedex_app_bar.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_card/pokemon_card.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_empty_list.dart';
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return const LandscapePokedexView();
          }
          return const PokedexView();
        },
      ),
    );
  }
}

class PokedexView extends StatelessWidget {
  const PokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PokedexAppBar(),
      body: Column(
        children: [
          OfflineModeBanner(),
          Expanded(child: PokedexBody()),
        ],
      ),
    );
  }
}

class PokedexBody extends StatefulWidget {
  const PokedexBody({super.key});

  @override
  State<PokedexBody> createState() => _PokedexBodyState();
}

class _PokedexBodyState extends State<PokedexBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<PokedexCubit>().state;
    // Prevent loading if already loading or loadingMore
    if (state.status == PokedexStatus.loading ||
        state.status == PokedexStatus.loadingMore) {
      return;
    }
    if (_isBottom) {
      unawaited(context.read<PokedexCubit>().loadPokemons());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PokedexCubit, PokedexState>(
      listener: (context, state) {
        if (state.status == PokedexStatus.failure && state.pokemons.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load pokemons')),
          );
        }
      },
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

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.5 / 3.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final pokemon = state.pokemons[index];
                    return PokemonCard(pokemon: pokemon);
                  },
                  childCount: state.pokemons.length,
                ),
              ),
            ),
            if (state.status == PokedexStatus.loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: PokeballSpinner(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
