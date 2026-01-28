import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  group('PokedexCubit', () {
    late PokemonRepository repository;

    setUp(() {
      repository = MockPokemonRepository();
    });

    test('initial state is correct', () {
      expect(
        PokedexCubit(repository: repository).state,
        const PokedexState(),
      );
    });

    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, success] when loadPokemons succeeds',
      build: () => PokedexCubit(repository: repository),
      setUp: () {
        when(
          () => repository.getPokemons(offset: any(named: 'offset')),
        ).thenAnswer((_) async => []);
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        const PokedexState(status: PokedexStatus.loading),
        const PokedexState(status: PokedexStatus.success),
      ],
    );

    blocTest<PokedexCubit, PokedexState>(
      'emits [loading, failure] when loadPokemons fails',
      build: () => PokedexCubit(repository: repository),
      setUp: () {
        when(
          () => repository.getPokemons(offset: any(named: 'offset')),
        ).thenThrow(Exception('oops'));
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        const PokedexState(status: PokedexStatus.loading),
        const PokedexState(status: PokedexStatus.failure),
      ],
    );
  });
}
