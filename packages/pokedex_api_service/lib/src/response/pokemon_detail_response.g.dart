// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonDetailResponse _$PokemonDetailResponseFromJson(
  Map<String, dynamic> json,
) => PokemonDetailResponse(
  id: (json['id'] as num).toInt(),
  baseExperience: json['base_experience'] as num,
  name: json['name'] as String,
  height: (json['height'] as num).toInt(),
  weight: (json['weight'] as num).toInt(),
  types: (json['types'] as List<dynamic>)
      .map((e) => PokemonTypeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  sprites: PokemonSpritesResponse.fromJson(
    json['sprites'] as Map<String, dynamic>,
  ),
);

PokemonTypeResponse _$PokemonTypeResponseFromJson(Map<String, dynamic> json) =>
    PokemonTypeResponse(
      slot: (json['slot'] as num).toInt(),
      type: NamedApiResource.fromJson(json['type'] as Map<String, dynamic>),
    );

PokemonSpritesResponse _$PokemonSpritesResponseFromJson(
  Map<String, dynamic> json,
) => PokemonSpritesResponse(
  frontDefault: json['front_default'] as String,
  backDefault: json['back_default'] as String?,
);

NamedApiResource _$NamedApiResourceFromJson(Map<String, dynamic> json) =>
    NamedApiResource(name: json['name'] as String, url: json['url'] as String);
