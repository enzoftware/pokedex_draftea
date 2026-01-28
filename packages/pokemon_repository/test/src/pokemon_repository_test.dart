import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/pokemon_repository.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';
import 'package:test/test.dart';

class MockPokedexApiService extends Mock implements PokedexApiService {}

class MockPokemonStorageService extends Mock implements PokemonStorageService {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('PokemonRepository', () {
    late PokedexApiService apiService;
    late PokemonStorageService storageService;
    late Connectivity connectivity;
    late PokemonRepository repository;

    const pokemon = Pokemon(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'image_url',
      baseExperience: 64,
      height: 7,
      weight: 69,
      types: [PokemonType(slot: 1, name: 'grass')],
      sprites: PokemonSprites(frontDefault: 'front'),
    );

    const pokemonEntity = PokemonEntity(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'image_url',
      height: 7,
      baseExperience: 64,
      weight: 69,
      types: [PokemonTypeEntity(slot: 1, name: 'grass')],
      sprites: PokemonSpritesEntity(frontDefault: 'front'),
    );

    setUp(() {
      apiService = MockPokedexApiService();
      storageService = MockPokemonStorageService();
      connectivity = MockConnectivity();
      repository = PokemonRepository(
        apiService: apiService,
        storageService: storageService,
        connectivity: connectivity,
      );
    });

    test('can be instantiated', () {
      expect(
        PokemonRepository(
          apiService: apiService,
          storageService: storageService,
          connectivity: connectivity,
        ),
        isNotNull,
      );
    });

    group('getPokemons', () {
      test('returns cached data when offline', () async {
        when(() => connectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.none],
        );
        when(() => storageService.getPokemons()).thenAnswer(
          (_) async => [pokemonEntity],
        );

        final result = await repository.getPokemons();

        expect(result, equals([pokemon]));
        verify(() => storageService.getPokemons()).called(1);
        verifyNever(() => apiService.getPokemonList());
      });

      test('fetches from API and saves to storage when online', () async {
        when(() => connectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.wifi],
        );

        const listResponse = PokemonListResponse(
          count: 1,
          results: [
            PokemonListItemResponse(
              name: 'bulbasaur',
              url: 'https://pokeapi.co/api/v2/pokemon/1/',
            ),
          ],
        );

        const detailResponse = PokemonDetailResponse(
          id: 1,
          name: 'bulbasaur',
          height: 7,
          baseExperience: 64,
          weight: 69,
          types: [
            PokemonTypeResponse(
              slot: 1,
              type: NamedApiResource(name: 'grass', url: 'url'),
            ),
          ],
          sprites: PokemonSpritesResponse(frontDefault: 'front'),
        );

        when(() => apiService.getPokemonList()).thenAnswer(
          (_) async => listResponse,
        );
        when(() => apiService.getPokemonDetail(id: '1')).thenAnswer(
          (_) async => detailResponse,
        );
        when(
          () => storageService.savePokemons(pokemons: any(named: 'pokemons')),
        ).thenAnswer((_) async {});

        final result = await repository.getPokemons();

        expect(result, isA<List<Pokemon>>());
        expect(result.first.name, 'bulbasaur');
        verify(
          () => storageService.savePokemons(pokemons: any(named: 'pokemons')),
        ).called(1);
      });

      test('throws GetPokemonsFailure with cache when API fails', () async {
        when(() => connectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.wifi],
        );
        when(
          () => apiService.getPokemonList(),
        ).thenThrow(Exception('API Error'));
        when(() => storageService.getPokemons()).thenAnswer(
          (_) async => [pokemonEntity],
        );

        try {
          await repository.getPokemons();
          fail('Should throw GetPokemonsFailure');
        } on GetPokemonsFailure catch (e) {
          expect(e.cachedPokemons, equals([pokemon]));
          expect(e.error, isA<Exception>());
        }
      });

      test(
        'throws GetPokemonsFailure with empty cache when API fails '
        'and no cache',
        () async {
          when(() => connectivity.checkConnectivity()).thenAnswer(
            (_) async => [ConnectivityResult.wifi],
          );
          when(
            () => apiService.getPokemonList(),
          ).thenThrow(Exception('API Error'));
          when(() => storageService.getPokemons()).thenAnswer(
            (_) async => [],
          );

          try {
            await repository.getPokemons();
            fail('Should throw GetPokemonsFailure');
          } on GetPokemonsFailure catch (e) {
            expect(e.cachedPokemons, isEmpty);
          }
        },
      );
    });
    group('clearPokemons', () {
      test('completes successfully when storage succeeds', () async {
        when(() => storageService.clearPokemons()).thenAnswer((_) async {});
        await expectLater(repository.clearPokemons(), completes);
        verify(() => storageService.clearPokemons()).called(1);
      });

      test('throws ClearPokemonsFailure when storage fails', () async {
        when(
          () => storageService.clearPokemons(),
        ).thenThrow(Exception('Storage error'));
        try {
          await repository.clearPokemons();
          fail('Should throw ClearPokemonsFailure');
        } on ClearPokemonsFailure catch (e) {
          expect(e.error, isA<Exception>());
        }
      });
    });

    group('getPokemonDetail', () {
      test('returns Pokemon when found in storage', () async {
        when(() => storageService.getPokemonById(id: '1')).thenAnswer(
          (_) async => pokemonEntity,
        );
        final result = await repository.getPokemonDetail(id: '1');
        expect(result, equals(pokemon));
      });

      test('throws GetPokemonDetailFailure when not found', () async {
        when(() => storageService.getPokemonById(id: '1')).thenAnswer(
          (_) async => null,
        );
        try {
          await repository.getPokemonDetail(id: '1');
          fail('Should throw GetPokemonDetailFailure');
        } on GetPokemonDetailFailure catch (e) {
          expect(e.error, isA<Exception>());
        }
      });

      test('throws GetPokemonDetailFailure when storage fails', () async {
        when(
          () => storageService.getPokemonById(id: '1'),
        ).thenThrow(Exception('Storage error'));
        try {
          await repository.getPokemonDetail(id: '1');
          fail('Should throw GetPokemonDetailFailure');
        } on GetPokemonDetailFailure catch (e) {
          expect(e.error, isA<Exception>());
        }
      });
    });
  });
}
