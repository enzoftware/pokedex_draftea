import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokedexCubit extends MockCubit<PokedexState>
    implements PokedexCubit {}

void main() {
  group('PokedexPage', () {
    late PokemonRepository repository;

    setUp(() {
      repository = MockPokemonRepository();
      when(() => repository.getPokemons()).thenAnswer((_) async => []);
    });

    testWidgets('renders PokedexView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: repository,
          child: const MaterialApp(home: PokedexPage()),
        ),
      );
      expect(find.byType(PokedexView), findsOneWidget);
    });
  });

  group('PokedexView', () {
    late PokedexCubit cubit;

    setUp(() {
      cubit = MockPokedexCubit();
    });

    testWidgets('renders loading indicator when status is loading', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokedexState(status: PokedexStatus.loading),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokedexView(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list of pokemons when status is success', (
      tester,
    ) async {
      const pokemon = Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url',
        height: 7,
        weight: 69,
        types: [],
        sprites: PokemonSprites(frontDefault: 'url'),
      );
      when(() => cubit.state).thenReturn(
        const PokedexState(
          status: PokedexStatus.success,
          pokemons: [pokemon],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PokedexView(),
          ),
        ),
      );
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('bulbasaur'), findsOneWidget);
    });

    testWidgets(
      'renders error message when status is failure and list is empty',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const PokedexState(status: PokedexStatus.failure),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: const PokedexView(),
            ),
          ),
        );
        expect(find.text('Failed to load Pokemons'), findsOneWidget);
      },
    );

    testWidgets(
      'renders empty message when status is success and list is empty',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const PokedexState(status: PokedexStatus.success),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: const PokedexView(),
            ),
          ),
        );
        expect(find.text('No Pokemons found'), findsOneWidget);
      },
    );
  });
}
