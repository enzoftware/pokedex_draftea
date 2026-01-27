import 'package:equatable/equatable.dart';
import 'package:pokedex_models/pokedex_models.dart';
import 'package:test/test.dart';

void main() {
  group('PokemonType', () {
    test('extends Equatable', () {
      expect(
        const PokemonType(slot: 1, name: 'grass'),
        isA<Equatable>(),
      );
    });

    test('supports value equality', () {
      const type1 = PokemonType(slot: 1, name: 'grass');
      const type2 = PokemonType(slot: 1, name: 'grass');
      const type3 = PokemonType(slot: 2, name: 'poison');

      expect(type1, equals(type2));
      expect(type1, isNot(equals(type3)));
    });

    test('props are correct', () {
      const type = PokemonType(slot: 1, name: 'grass');
      expect(type.props, equals([1, 'grass']));
    });
  });
}
