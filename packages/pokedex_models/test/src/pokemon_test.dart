import 'package:equatable/equatable.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:test/test.dart';

void main() {
  group('Pokemon', () {
    const type = PokemonType(slot: 1, name: 'grass');
    const sprites = PokemonSprites(frontDefault: 'url1');

    test('extends Equatable', () {
      expect(
        const Pokemon(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          height: 7,
          weight: 69,
          types: [type],
          sprites: sprites,
        ),
        isA<Equatable>(),
      );
    });

    test('supports value equality', () {
      const pokemon1 = Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url',
        height: 7,
        weight: 69,
        types: [type],
        sprites: sprites,
      );
      const pokemon2 = Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url',
        height: 7,
        weight: 69,
        types: [type],
        sprites: sprites,
      );
      const pokemon3 = Pokemon(
        id: 2,
        name: 'ivysaur',
        imageUrl: 'url',
        height: 10,
        weight: 130,
        types: [type],
        sprites: sprites,
      );

      expect(pokemon1, equals(pokemon2));
      expect(pokemon1, isNot(equals(pokemon3)));
    });

    test('props are correct', () {
      const pokemon = Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url',
        height: 7,
        weight: 69,
        types: [type],
        sprites: sprites,
      );

      expect(
        pokemon.props,
        equals([
          1,
          'bulbasaur',
          'url',
          7,
          69,
          [type],
          sprites,
        ]),
      );
    });
  });
}
