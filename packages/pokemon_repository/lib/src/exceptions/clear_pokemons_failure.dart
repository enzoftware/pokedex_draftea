class ClearPokemonsFailure implements Exception {
  const ClearPokemonsFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
