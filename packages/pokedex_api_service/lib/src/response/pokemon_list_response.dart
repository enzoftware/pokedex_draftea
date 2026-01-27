import 'package:json_annotation/json_annotation.dart';

part 'pokemon_list_response.g.dart';

@JsonSerializable()
class PokemonListResponse {
  const PokemonListResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);

  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemResponse> results;

  Map<String, dynamic> toJson() => _$PokemonListResponseToJson(this);
}

@JsonSerializable()
class PokemonListItemResponse {
  const PokemonListItemResponse({
    required this.name,
    required this.url,
  });

  factory PokemonListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemResponseFromJson(json);

  final String name;
  final String url;

  Map<String, dynamic> toJson() => _$PokemonListItemResponseToJson(this);

  String get id {
    final uri = Uri.parse(url);
    // The id is the last segment of the path
    // e.g. https://pokeapi.co/api/v2/pokemon/1/ -> 1
    final segments = uri.pathSegments.where((e) => e.isNotEmpty).toList();
    return segments.last;
  }
}
