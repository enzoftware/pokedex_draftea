import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_cubit.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_state.dart';
import 'package:pokedex_draftea/pokemon_detail/view/pokemon_detail_page.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokedexDetailCubit extends MockCubit<PokemonDetailState>
    implements PokedexDetailCubit {}

void main() {
  const testPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl: 'https://example.com/bulbasaur.png',
    height: 7,
    weight: 69,
    baseExperience: 64,
    types: [
      PokemonType(slot: 1, name: 'grass'),
      PokemonType(slot: 2, name: 'poison'),
    ],
    sprites: PokemonSprites(
      frontDefault: 'https://example.com/front.png',
      backDefault: 'https://example.com/back.png',
    ),
  );

  group('PokemonDetailPage', () {
    late PokemonRepository repository;

    setUp(() {
      repository = MockPokemonRepository();
      when(
        () => repository.getPokemonDetail(id: any(named: 'id')),
      ).thenAnswer((_) async => testPokemon);
    });

    testWidgets('renders PokemonDetailView in portrait', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: repository,
          child: const MaterialApp(
            home: PokemonDetailPage(pokemonId: '1'),
          ),
        ),
      );
      expect(find.byType(PokemonDetailView), findsOneWidget);
    });
  });

  group('PokemonDetailView', () {
    late PokedexDetailCubit cubit;

    setUp(() {
      cubit = MockPokedexDetailCubit();
    });

    testWidgets('renders loading indicator when status is loading', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(status: PokemonDetailStatus.loading),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.byType(PokeballSpinner), findsOneWidget);
    });

    testWidgets('renders loading indicator when status is initial', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.byType(PokeballSpinner), findsOneWidget);
    });

    testWidgets('renders error view when status is failure', (tester) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(status: PokemonDetailStatus.failure),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('Failed to load Pokemon details'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry button calls getPokemonDetail', (tester) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(status: PokemonDetailStatus.failure),
      );
      when(() => cubit.getPokemonDetail(id: '1')).thenAnswer((_) async {});
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      await tester.tap(find.text('Retry'));
      verify(() => cubit.getPokemonDetail(id: '1')).called(1);
    });

    testWidgets('renders pokemon details when status is success', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemon: testPokemon,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('BULBASAUR'), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
    });

    testWidgets('displays pokemon types', (tester) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemon: testPokemon,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('Types'), findsOneWidget);
      expect(find.text('GRASS'), findsOneWidget);
      expect(find.text('POISON'), findsOneWidget);
    });

    testWidgets('displays pokemon stats', (tester) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemon: testPokemon,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('Stats'), findsOneWidget);
      expect(find.text('Base Experience'), findsOneWidget);
      expect(find.text('64'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);
      expect(find.text('0.7 m'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('6.9 kg'), findsOneWidget);
    });

    testWidgets('displays pokemon sprites section', (tester) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemon: testPokemon,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('Sprites'), findsOneWidget);
      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('shows snackbar on failure transition', (tester) async {
      final statesController = StreamController<PokemonDetailState>();
      whenListen(
        cubit,
        statesController.stream,
        initialState: const PokemonDetailState(
          status: PokemonDetailStatus.loading,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      statesController.add(
        const PokemonDetailState(status: PokemonDetailStatus.failure),
      );
      await tester.pump();
      expect(find.text('Failed to load Pokemon details'), findsWidgets);
      await statesController.close();
    });

    testWidgets('displays default app bar title when pokemon is null', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokemonDetailState(status: PokemonDetailStatus.loading),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokemonDetailView(pokemonId: '1'),
          ),
        ),
      );
      expect(find.text('Pokemon Details'), findsOneWidget);
    });
  });
}
