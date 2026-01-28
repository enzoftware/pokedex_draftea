import 'package:equatable/equatable.dart';
import 'package:pokedex_models/src/pokemon_sprites.dart';
import 'package:pokedex_models/src/pokemon_type.dart';

class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.baseExperience,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.sprites,
  });

  final int id;
  final int baseExperience;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final PokemonSprites sprites;

  @override
  List<Object?> get props => [
    id,
    baseExperience,
    name,
    imageUrl,
    height,
    weight,
    types,
    sprites,
  ];
}
