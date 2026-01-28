import 'package:json_annotation/json_annotation.dart';
import 'package:pokedex_models/pokedex_models.dart';

part 'pokemon_detail_response.g.dart';

@JsonSerializable(createToJson: false)
class PokemonDetailResponse {
  const PokemonDetailResponse({
    required this.id,
    required this.baseExperience,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.sprites,
  });

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseFromJson(json);

  final int id;
  @JsonKey(name: 'base_experience')
  final num baseExperience;
  final String name;
  final int height;
  final int weight;
  final List<PokemonTypeResponse> types;
  final PokemonSpritesResponse sprites;

  Pokemon toPokemon() {
    return Pokemon(
      id: id,
      baseExperience: baseExperience.toInt(),
      name: name,
      imageUrl: sprites.frontDefault,
      height: height,
      weight: weight,
      types: types
          .map((e) => PokemonType(slot: e.slot, name: e.type.name))
          .toList(),
      sprites: PokemonSprites(
        frontDefault: sprites.frontDefault,
        backDefault: sprites.backDefault,
      ),
    );
  }
}

@JsonSerializable(createToJson: false)
class PokemonTypeResponse {
  const PokemonTypeResponse({
    required this.slot,
    required this.type,
  });

  factory PokemonTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeResponseFromJson(json);

  final int slot;
  final NamedApiResource type;
}

@JsonSerializable(createToJson: false)
class PokemonSpritesResponse {
  const PokemonSpritesResponse({
    required this.frontDefault,
    this.backDefault,
  });

  factory PokemonSpritesResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesResponseFromJson(json);

  @JsonKey(name: 'front_default')
  final String frontDefault;

  @JsonKey(name: 'back_default')
  final String? backDefault;
}

@JsonSerializable(createToJson: false)
class NamedApiResource {
  const NamedApiResource({
    required this.name,
    required this.url,
  });

  factory NamedApiResource.fromJson(Map<String, dynamic> json) =>
      _$NamedApiResourceFromJson(json);

  final String name;
  final String url;
}
