import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_cubit.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_state.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  group('PokedexDetailCubit', () {
    late PokemonRepository repository;

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

    setUp(() {
      repository = MockPokemonRepository();
    });

    test('initial state is correct', () {
      expect(
        PokedexDetailCubit(pokemonRepository: repository).state,
        const PokemonDetailState(),
      );
    });

    test('initial state has initial status', () {
      final cubit = PokedexDetailCubit(pokemonRepository: repository);
      expect(cubit.state.status, PokemonDetailStatus.initial);
      expect(cubit.state.pokemon, isNull);
      expect(cubit.state.error, isNull);
    });

    group('getPokemonDetail', () {
      blocTest<PokedexDetailCubit, PokemonDetailState>(
        'emits [loading, success] when getPokemonDetail succeeds',
        build: () => PokedexDetailCubit(pokemonRepository: repository),
        setUp: () {
          when(
            () => repository.getPokemonDetail(id: any(named: 'id')),
          ).thenAnswer((_) async => testPokemon);
        },
        act: (cubit) => cubit.getPokemonDetail(id: '1'),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          const PokemonDetailState(
            status: PokemonDetailStatus.success,
            pokemon: testPokemon,
          ),
        ],
        verify: (_) {
          verify(() => repository.getPokemonDetail(id: '1')).called(1);
        },
      );

      blocTest<PokedexDetailCubit, PokemonDetailState>(
        'emits [loading, failure] when getPokemonDetail fails',
        build: () => PokedexDetailCubit(pokemonRepository: repository),
        setUp: () {
          when(
            () => repository.getPokemonDetail(id: any(named: 'id')),
          ).thenThrow(Exception('Failed to fetch pokemon'));
        },
        act: (cubit) => cubit.getPokemonDetail(id: '1'),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          isA<PokemonDetailState>()
              .having((s) => s.status, 'status', PokemonDetailStatus.failure)
              .having((s) => s.error, 'error', isA<Exception>()),
        ],
        verify: (_) {
          verify(() => repository.getPokemonDetail(id: '1')).called(1);
        },
      );

      blocTest<PokedexDetailCubit, PokemonDetailState>(
        'emits [loading, failure] when GetPokemonDetailFailure is thrown',
        build: () => PokedexDetailCubit(pokemonRepository: repository),
        setUp: () {
          when(
            () => repository.getPokemonDetail(id: any(named: 'id')),
          ).thenThrow(
            GetPokemonDetailFailure(Exception('API error'), StackTrace.empty),
          );
        },
        act: (cubit) => cubit.getPokemonDetail(id: '25'),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          isA<PokemonDetailState>()
              .having((s) => s.status, 'status', PokemonDetailStatus.failure)
              .having((s) => s.error, 'error', isA<GetPokemonDetailFailure>()),
        ],
      );

      blocTest<PokedexDetailCubit, PokemonDetailState>(
        'can fetch different pokemon by id',
        build: () => PokedexDetailCubit(pokemonRepository: repository),
        setUp: () {
          when(
            () => repository.getPokemonDetail(id: '25'),
          ).thenAnswer(
            (_) async => testPokemon.copyWith(id: 25, name: 'pikachu'),
          );
        },
        act: (cubit) => cubit.getPokemonDetail(id: '25'),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          PokemonDetailState(
            status: PokemonDetailStatus.success,
            pokemon: testPokemon.copyWith(id: 25, name: 'pikachu'),
          ),
        ],
        verify: (_) {
          verify(() => repository.getPokemonDetail(id: '25')).called(1);
        },
      );
    });
  });
}

extension on Pokemon {
  Pokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? height,
    int? weight,
    int? baseExperience,
    List<PokemonType>? types,
    PokemonSprites? sprites,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      baseExperience: baseExperience ?? this.baseExperience,
      types: types ?? this.types,
      sprites: sprites ?? this.sprites,
    );
  }
}
