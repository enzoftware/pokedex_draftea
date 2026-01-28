import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';
import 'package:test/test.dart';

class MockBox extends Mock implements Box<PokemonEntity> {}

void main() {
  group('PokemonHiveStorageService', () {
    late Box<PokemonEntity> box;
    late PokemonHiveStorageService storageService;

    setUp(() {
      box = MockBox();
      storageService = PokemonHiveStorageService(pokemonBox: box);
    });

    group('getPokemons', () {
      test('returns list of entities from box', () async {
        const entity = PokemonEntity(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        when(() => box.values).thenReturn([entity]);

        final result = await storageService.getPokemons();

        expect(result, equals([entity]));
        verify(() => box.values).called(1);
      });

      test('returns empty list when box is empty', () async {
        when(() => box.values).thenReturn([]);

        final result = await storageService.getPokemons();

        expect(result, isEmpty);
      });
    });

    group('getPokemon', () {
      test('returns entity when found', () async {
        const entity = PokemonEntity(
          id: 1,
          name: 'bulbasaur',
          baseExperience: 64,
          imageUrl: 'url',
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        when(() => box.get('1')).thenReturn(entity);

        final result = await storageService.getPokemonById(id: '1');

        expect(result, equals(entity));
        verify(() => box.get('1')).called(1);
      });

      test('returns null when not found', () async {
        when(() => box.get('1')).thenReturn(null);

        final result = await storageService.getPokemonById(id: '1');

        expect(result, isNull);
      });
    });

    group('savePokemons', () {
      test('puts entities into box', () async {
        const pokemon = Pokemon(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSprites(frontDefault: 'url'),
        );

        when(() => box.putAll(any())).thenAnswer((_) async {});

        await storageService.savePokemons(pokemons: [pokemon]);

        verify(() => box.putAll(any())).called(1);
      });
    });

    group('clearPokemons', () {
      test('clears box', () async {
        when(() => box.clear()).thenAnswer((_) async => 0);

        await storageService.clearPokemons();

        verify(() => box.clear()).called(1);
      });
    });
  });
}
