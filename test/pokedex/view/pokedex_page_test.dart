import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_draftea/app/cubit/app_cubit.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokemon_card/pokemon_card.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokedexCubit extends MockCubit<PokedexState>
    implements PokedexCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  group('PokedexPage', () {
    late PokemonRepository repository;
    late AppCubit appCubit;

    setUp(() {
      repository = MockPokemonRepository();
      when(
        () => repository.getPokemons(offset: any(named: 'offset')),
      ).thenAnswer((_) async => []);
      appCubit = MockAppCubit();
      when(() => appCubit.state).thenReturn(const AppState());
    });

    testWidgets('renders PokedexView', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: repository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: appCubit,
              child: const PokedexPage(),
            ),
          ),
        ),
      );
      expect(find.byType(PokedexView), findsOneWidget);
    });
  });

  group('PokedexView', () {
    late PokedexCubit cubit;
    late AppCubit appCubit;

    setUp(() {
      cubit = MockPokedexCubit();
      appCubit = MockAppCubit();
      when(() => appCubit.state).thenReturn(const AppState());
    });

    testWidgets('renders loading indicator when status is loading', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const PokedexState(status: PokedexStatus.loading),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: appCubit),
            ],
            child: const PokedexView(),
          ),
        ),
      );
      expect(find.byType(PokeballSpinner), findsOneWidget);
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
        baseExperience: 64,
        types: [],
        sprites: PokemonSprites(frontDefault: 'url'),
      );
      when(() => cubit.state).thenReturn(
        const PokedexState(
          status: PokedexStatus.success,
          pokemons: [pokemon],
        ),
      );
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: appCubit),
            ],
            child: const PokedexView(),
          ),
        ),
      );
      // Pump to render the initial frame
      await tester.pump();
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(PokemonCard), findsOneWidget);
      // Pump entrance animation (500ms)
      await tester.pump(const Duration(milliseconds: 600));
      // Pump delay (200ms)
      await tester.pump(const Duration(milliseconds: 300));
      // Pump flip animation (800ms)
      await tester.pump(const Duration(milliseconds: 900));
    });

    testWidgets(
      'renders error message when status is failure and list is empty',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const PokedexState(status: PokedexStatus.failure),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider.value(value: appCubit),
              ],
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
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider.value(value: appCubit),
              ],
              child: const PokedexView(),
            ),
          ),
        );
        expect(find.text('No Pokemons found'), findsOneWidget);
      },
    );
  });
}
