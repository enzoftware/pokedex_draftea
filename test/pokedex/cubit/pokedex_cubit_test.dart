import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_draftea/pokedex/pokedex.dart';

void main() {
  group('CounterCubit', () {
    test('initial state is 0', () {
      expect(PokedexCubit().state, equals(0));
    });

    blocTest<PokedexCubit, int>(
      'emits [1] when increment is called',
      build: PokedexCubit.new,
      act: (cubit) => cubit.increment(),
      expect: () => [equals(1)],
    );

    blocTest<PokedexCubit, int>(
      'emits [-1] when decrement is called',
      build: PokedexCubit.new,
      act: (cubit) => cubit.decrement(),
      expect: () => [equals(-1)],
    );
  });
}
