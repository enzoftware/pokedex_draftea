import 'package:hive_ce/hive.dart';
import 'package:pokedex_models/pokedex_models.dart';

part 'pokemon_entity.g.dart';

@HiveType(typeId: 0)
class PokemonEntity {
  const PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.sprites,
  });

  factory PokemonEntity.fromDomain(Pokemon pokemon) {
    return PokemonEntity(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      height: pokemon.height,
      weight: pokemon.weight,
      types: pokemon.types.map(PokemonTypeEntity.fromDomain).toList(),
      sprites: PokemonSpritesEntity.fromDomain(pokemon.sprites),
    );
  }

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final int height;

  @HiveField(4)
  final int weight;

  @HiveField(5)
  final List<PokemonTypeEntity> types;

  @HiveField(6)
  final PokemonSpritesEntity sprites;

  Pokemon toDomain() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      types: types.map((e) => e.toDomain()).toList(),
      sprites: sprites.toDomain(),
    );
  }
}

@HiveType(typeId: 1)
class PokemonTypeEntity {
  const PokemonTypeEntity({
    required this.slot,
    required this.name,
  });

  factory PokemonTypeEntity.fromDomain(PokemonType type) {
    return PokemonTypeEntity(
      slot: type.slot,
      name: type.name,
    );
  }

  @HiveField(0)
  final int slot;

  @HiveField(1)
  final String name;

  PokemonType toDomain() {
    return PokemonType(
      slot: slot,
      name: name,
    );
  }
}

@HiveType(typeId: 2)
class PokemonSpritesEntity {
  const PokemonSpritesEntity({
    required this.frontDefault,
    this.backDefault,
  });

  factory PokemonSpritesEntity.fromDomain(PokemonSprites sprites) {
    return PokemonSpritesEntity(
      frontDefault: sprites.frontDefault,
      backDefault: sprites.backDefault,
    );
  }

  @HiveField(0)
  final String frontDefault;

  @HiveField(1)
  final String? backDefault;

  PokemonSprites toDomain() {
    return PokemonSprites(
      frontDefault: frontDefault,
      backDefault: backDefault,
    );
  }
}
