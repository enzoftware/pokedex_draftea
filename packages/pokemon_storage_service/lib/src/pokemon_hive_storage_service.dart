import 'package:hive_ce/hive.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

class PokemonHiveStorageService implements PokemonStorageService {
  PokemonHiveStorageService({
    Box<PokemonEntity>? pokemonBox,
  }) : _pokemonBox = pokemonBox ?? Hive.box<PokemonEntity>('pokemons');

  final Box<PokemonEntity> _pokemonBox;

  @override
  Future<List<PokemonEntity>> getCachePokemons({
    required int offset,
    required int limit,
  }) async {
    final allPokemons = _pokemonBox.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (offset >= allPokemons.length) {
      return [];
    }

    final end = (offset + limit).clamp(0, allPokemons.length);
    return allPokemons.sublist(offset, end);
  }

  @override
  Future<int> getPokemonsCount() async {
    return _pokemonBox.length;
  }

  @override
  Future<PokemonEntity?> getPokemonById({required String id}) async {
    final entity = _pokemonBox.get(id);
    return entity;
  }

  @override
  Future<void> savePokemons({required List<Pokemon> pokemons}) async {
    final entities = {
      for (final p in pokemons) p.id.toString(): PokemonEntity.fromDomain(p),
    };
    await _pokemonBox.putAll(entities);
  }

  @override
  Future<void> clearPokemons() async {
    await _pokemonBox.clear();
  }
}
