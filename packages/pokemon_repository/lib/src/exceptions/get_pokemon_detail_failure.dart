class GetPokemonDetailFailure implements Exception {
  const GetPokemonDetailFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
