import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_repository/src/exceptions/clear_pokemons_failure.dart';
import 'package:pokemon_repository/src/exceptions/get_pokemon_detail_failure.dart';
import 'package:pokemon_repository/src/exceptions/get_pokemons_failure.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

class PokemonRepository {
  const PokemonRepository({
    required PokedexApiService apiService,
    required PokemonStorageService storageService,
    required Connectivity connectivity,
  }) : _apiService = apiService,
       _storageService = storageService,
       _connectivity = connectivity;

  final PokemonStorageService _storageService;
  final PokedexApiService _apiService;
  final Connectivity _connectivity;

  Future<List<Pokemon>> getPokemons({
    int offset = 0,
    int limit = 10,
  }) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      final entities = await _storageService.getCachePokemons(
        offset: offset,
        limit: limit,
      );
      return entities.map((e) => e.toDomain()).toList();
    }

    try {
      final response = await _apiService.getPokemonList(
        limit: limit,
        offset: offset,
      );
      final details = await Future.wait(
        response.results.map(
          (pokemon) => _apiService.getPokemonDetail(id: pokemon.id),
        ),
      );

      final pokemons = details
          .map((pkmnDetail) => pkmnDetail.toPokemon())
          .toList();

      await _storageService.savePokemons(pokemons: pokemons);

      return pokemons;
    } catch (error, stackTrace) {
      // On error, try to return cached data for this page
      final entities = await _storageService.getCachePokemons(
        offset: offset,
        limit: limit,
      );
      if (entities.isNotEmpty) {
        final cachedPokemons = entities.map((e) => e.toDomain()).toList();
        throw GetPokemonsFailure(error, stackTrace, cachedPokemons);
      }
      rethrow;
    }
  }

  Future<void> clearPokemons() async {
    try {
      await _storageService.clearPokemons();
    } catch (error, stackTrace) {
      throw ClearPokemonsFailure(error, stackTrace);
    }
  }

  Future<Pokemon> getPokemonDetail({required String id}) async {
    try {
      final entity = await _storageService.getPokemonById(id: id);
      if (entity == null) {
        throw GetPokemonDetailFailure(
          Exception('Pokemon not found'),
          StackTrace.current,
        );
      }
      return entity.toDomain();
    } catch (error, stackTrace) {
      if (error is GetPokemonDetailFailure) rethrow;
      throw GetPokemonDetailFailure(error, stackTrace);
    }
  }
}
