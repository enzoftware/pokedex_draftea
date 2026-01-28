import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_cache_image.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_card/pokemon_type_badge.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_cubit.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_state.dart';
import 'package:pokedex_draftea/pokemon_detail/view/landscape_pokemon_detail_view.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({required this.pokemonId, super.key});

  final String pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokedexDetailCubit(
        pokemonRepository: context.read<PokemonRepository>(),
      )..getPokemonDetail(id: pokemonId),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return LandscapePokemonDetailView(pokemonId: pokemonId);
          }
          return PokemonDetailView(pokemonId: pokemonId);
        },
      ),
    );
  }
}

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({required this.pokemonId, super.key});

  final String pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PokedexDetailCubit, PokemonDetailState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == PokemonDetailStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load Pokemon details'),
            backgroundColor: Colors.red,
          ),
        );
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.pokemon != current.pokemon,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              state.pokemon?.name.toUpperCase() ?? 'Pokemon Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              Text(
                '#${state.pokemon?.id ?? ''}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: switch (state.status) {
            PokemonDetailStatus.initial ||
            PokemonDetailStatus.loading =>
              const _PokemonDetailLoading(),
            PokemonDetailStatus.failure => _PokemonDetailError(
                pokemonId: pokemonId,
              ),
            PokemonDetailStatus.success => _PokemonDetailContent(
                pokemon: state.pokemon!,
              ),
          },
        );
      },
    );
  }
}

class _PokemonDetailLoading extends StatelessWidget {
  const _PokemonDetailLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: PokeballSpinner(),
    );
  }
}

class _PokemonDetailError extends StatelessWidget {
  const _PokemonDetailError({required this.pokemonId});

  final String pokemonId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PokeballImage(),
          const SizedBox(height: 16),
          const Text('Failed to load Pokemon details'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<PokedexDetailCubit>()
                .getPokemonDetail(id: pokemonId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _PokemonDetailContent extends StatelessWidget {
  const _PokemonDetailContent({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PokemonImage(pokemon: pokemon),
          const SizedBox(height: 24),
          _PokemonTypes(types: pokemon.types),
          const SizedBox(height: 24),
          _PokemonStats(pokemon: pokemon),
          const SizedBox(height: 24),
          _PokemonSprites(sprites: pokemon.sprites),
        ],
      ),
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemon_${pokemon.id}',
      child: PokemonCacheImage(
        imageUrl: pokemon.imageUrl,
        size: 200,
      ),
    );
  }
}

class _PokemonTypes extends StatelessWidget {
  const _PokemonTypes({required this.types});

  final List<PokemonType> types;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Types',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: types
              .map(
                (type) => PokemonTypeBadge(type: type.name),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PokemonStats extends StatelessWidget {
  const _PokemonStats({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Base Experience',
              value: '${pokemon.baseExperience}',
            ),
            const Divider(),
            _StatRow(label: 'Height', value: '${pokemon.height / 10} m'),
            const Divider(),
            _StatRow(label: 'Weight', value: '${pokemon.weight / 10} kg'),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge,
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonSprites extends StatelessWidget {
  const _PokemonSprites({required this.sprites});

  final PokemonSprites sprites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sprites',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SpriteCard(
              label: 'Front',
              imageUrl: sprites.frontDefault,
            ),
            if (sprites.backDefault != null)
              _SpriteCard(
                label: 'Back',
                imageUrl: sprites.backDefault!,
              ),
          ],
        ),
      ],
    );
  }
}

class _SpriteCard extends StatelessWidget {
  const _SpriteCard({required this.label, required this.imageUrl});

  final String label;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            PokemonCacheImage(
              imageUrl: imageUrl,
              size: 80,
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
