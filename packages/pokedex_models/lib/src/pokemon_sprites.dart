import 'package:equatable/equatable.dart';

class PokemonSprites extends Equatable {
  const PokemonSprites({
    required this.frontDefault,
    this.backDefault,
  });

  final String frontDefault;
  final String? backDefault;

  @override
  List<Object?> get props => [frontDefault, backDefault];
}
