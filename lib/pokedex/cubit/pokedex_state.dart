import 'package:equatable/equatable.dart';
import 'package:pokedex_models/pokedex_models.dart';

enum PokedexStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

class PokedexState extends Equatable {
  const PokedexState({
    this.status = PokedexStatus.initial,
    this.pokemons = const [],
  });

  final PokedexStatus status;
  final List<Pokemon> pokemons;

  PokedexState copyWith({
    PokedexStatus? status,
    List<Pokemon>? pokemons,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
    );
  }

  @override
  List<Object?> get props => [status, pokemons];
}
