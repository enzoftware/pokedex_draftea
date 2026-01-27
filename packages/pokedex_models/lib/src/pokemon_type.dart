import 'package:equatable/equatable.dart';

class PokemonType extends Equatable {
  const PokemonType({
    required this.slot,
    required this.name,
  });

  final int slot;
  final String name;

  @override
  List<Object?> get props => [slot, name];
}
