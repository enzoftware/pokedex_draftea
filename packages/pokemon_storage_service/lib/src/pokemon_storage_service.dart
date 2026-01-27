import 'package:pokedex_models/pokedex_models.dart' show Pokemon;
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

abstract class PokemonStorageService {
  Future<List<PokemonEntity>> getPokemons();

  Future<PokemonEntity?> getPokemon({required String id});

  Future<void> savePokemons({required List<Pokemon> pokemons});

  Future<void> clearPokemons();
}
