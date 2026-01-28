import 'package:equatable/equatable.dart';
import 'package:pokedex_models/pokedex_models.dart';

enum PokemonDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class PokemonDetailState extends Equatable {
  const PokemonDetailState({
    this.status = PokemonDetailStatus.initial,
    this.pokemon,
    this.error,
  });

  final PokemonDetailStatus status;
  final Pokemon? pokemon;
  final Object? error;

  PokemonDetailState copyWith({
    PokemonDetailStatus? status,
    Pokemon? pokemon,
    Object? error,
  }) {
    return PokemonDetailState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, pokemon, error];
}
