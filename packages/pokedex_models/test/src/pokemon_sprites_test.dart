import 'package:equatable/equatable.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:test/test.dart';

void main() {
  group('PokemonSprites', () {
    test('extends Equatable', () {
      expect(
        const PokemonSprites(frontDefault: 'url1'),
        isA<Equatable>(),
      );
    });

    test('supports value equality', () {
      const sprites1 = PokemonSprites(
        frontDefault: 'url1',
        backDefault: 'url2',
      );
      const sprites2 = PokemonSprites(
        frontDefault: 'url1',
        backDefault: 'url2',
      );
      const sprites3 = PokemonSprites(frontDefault: 'url1');

      expect(sprites1, equals(sprites2));
      expect(sprites1, isNot(equals(sprites3)));
    });

    test('props are correct', () {
      const sprites = PokemonSprites(frontDefault: 'url1', backDefault: 'url2');
      expect(sprites.props, equals(['url1', 'url2']));
    });
  });
}
