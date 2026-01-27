import 'package:pokedex_models/pokedex_models.dart';

class GetPokemonsFailure implements Exception {
  const GetPokemonsFailure(
    this.error,
    this.stackTrace, [
    this.cachedPokemons,
  ]);

  final Object error;
  final StackTrace stackTrace;
  final List<Pokemon>? cachedPokemons;
}
