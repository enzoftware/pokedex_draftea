import 'package:pokedex_models/pokedex_models.dart';
import 'package:pokemon_storage_service/src/entity/pokemon_entity.dart';
import 'package:test/test.dart';

void main() {
  group('PokemonEntity', () {
    const pokemon = Pokemon(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'url',
      height: 7,
      baseExperience: 64,
      weight: 69,
      types: [PokemonType(slot: 1, name: 'grass')],
      sprites: PokemonSprites(frontDefault: 'front', backDefault: 'back'),
    );

    test('fromDomain creates correct entity', () {
      final entity = PokemonEntity.fromDomain(pokemon);

      expect(entity.id, pokemon.id);
      expect(entity.name, pokemon.name);
      expect(entity.imageUrl, pokemon.imageUrl);
      expect(entity.height, pokemon.height);
      expect(entity.weight, pokemon.weight);
      expect(entity.types.length, pokemon.types.length);
      expect(entity.types.first.slot, pokemon.types.first.slot);
      expect(entity.types.first.name, pokemon.types.first.name);
      expect(entity.sprites.frontDefault, pokemon.sprites.frontDefault);
      expect(entity.sprites.backDefault, pokemon.sprites.backDefault);
    });

    test('toDomain creates correct model', () {
      final entity = PokemonEntity.fromDomain(pokemon);
      final model = entity.toDomain();

      expect(model.id, pokemon.id);
      expect(model.name, pokemon.name);
      expect(model.imageUrl, pokemon.imageUrl);
      expect(model.height, pokemon.height);
      expect(model.weight, pokemon.weight);
      expect(model.types.length, pokemon.types.length);
      expect(model.types.first.slot, pokemon.types.first.slot);
      expect(model.types.first.name, pokemon.types.first.name);
      expect(model.sprites.frontDefault, pokemon.sprites.frontDefault);
      expect(model.sprites.backDefault, pokemon.sprites.backDefault);
    });
  });
}
