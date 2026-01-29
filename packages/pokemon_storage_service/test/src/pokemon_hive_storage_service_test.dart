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

    group('getCachePokemons', () {
      test('returns paginated list sorted by id', () async {
        const entity1 = PokemonEntity(
          id: 3,
          name: 'venusaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        const entity2 = PokemonEntity(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        const entity3 = PokemonEntity(
          id: 2,
          name: 'ivysaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        when(() => box.values).thenReturn([entity1, entity2, entity3]);

        final result = await storageService.getCachePokemons(
          offset: 0,
          limit: 2,
        );

        expect(result.length, equals(2));
        expect(result[0].id, equals(1));
        expect(result[1].id, equals(2));
      });

      test('returns empty list when offset exceeds count', () async {
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

        final result = await storageService.getCachePokemons(
          offset: 5,
          limit: 10,
        );

        expect(result, isEmpty);
      });

      test('returns remaining items when limit exceeds available', () async {
        const entity1 = PokemonEntity(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        const entity2 = PokemonEntity(
          id: 2,
          name: 'ivysaur',
          imageUrl: 'url',
          baseExperience: 64,
          height: 7,
          weight: 69,
          types: [],
          sprites: PokemonSpritesEntity(frontDefault: 'url'),
        );
        when(() => box.values).thenReturn([entity1, entity2]);

        final result = await storageService.getCachePokemons(
          offset: 1,
          limit: 10,
        );

        expect(result.length, equals(1));
        expect(result[0].id, equals(2));
      });
    });

    group('getPokemonsCount', () {
      test('returns the count of pokemons in box', () async {
        when(() => box.length).thenReturn(5);

        final result = await storageService.getPokemonsCount();

        expect(result, equals(5));
      });

      test('returns 0 when box is empty', () async {
        when(() => box.length).thenReturn(0);

        final result = await storageService.getPokemonsCount();

        expect(result, equals(0));
      });
    });

    group('getPokemonById', () {
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
