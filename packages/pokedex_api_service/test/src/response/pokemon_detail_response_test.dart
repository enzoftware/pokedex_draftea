import 'package:pokedex_api_service/src/response/pokemon_detail_response.dart';
import 'package:test/test.dart';

void main() {
  group('PokemonDetailResponse', () {
    test('fromJson parses correctly', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'bulbasaur',
        'height': 7,
        'weight': 69,
        'types': [
          {
            'slot': 1,
            'type': {
              'name': 'grass',
              'url': 'https://pokeapi.co/api/v2/type/12/',
            },
          },
        ],
        'sprites': {
          'front_default':
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
          'back_default':
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png',
        },
      };

      final response = PokemonDetailResponse.fromJson(json);

      expect(response.id, 1);
      expect(response.name, 'bulbasaur');
      expect(response.height, 7);
      expect(response.weight, 69);
      expect(response.types, hasLength(1));
      expect(response.types.first.slot, 1);
      expect(response.types.first.type.name, 'grass');
      expect(
        response.types.first.type.url,
        'https://pokeapi.co/api/v2/type/12/',
      );
      expect(
        response.sprites.frontDefault,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      );
      expect(
        response.sprites.backDefault,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png',
      );
    });

    test('fromJson handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'bulbasaur',
        'height': 7,
        'weight': 69,
        'types': <Map<String, dynamic>>[],
        'sprites': {
          'front_default':
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        },
      };

      final response = PokemonDetailResponse.fromJson(json);

      expect(response.sprites.backDefault, isNull);
      expect(response.types, isEmpty);
    });

    test('toPokemon maps correctly', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'bulbasaur',
        'height': 7,
        'weight': 69,
        'types': [
          {
            'slot': 1,
            'type': {
              'name': 'grass',
              'url': 'https://pokeapi.co/api/v2/type/12/',
            },
          },
        ],
        'sprites': {
          'front_default':
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
          'back_default':
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png',
        },
      };

      final response = PokemonDetailResponse.fromJson(json);
      final pokemon = response.toPokemon();

      expect(pokemon.id, 1);
      expect(pokemon.name, 'bulbasaur');
      expect(pokemon.height, 7);
      expect(pokemon.weight, 69);
      expect(
        pokemon.imageUrl,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      );
      expect(pokemon.types, hasLength(1));
      expect(pokemon.types.first.slot, 1);
      expect(pokemon.types.first.name, 'grass');
      expect(
        pokemon.sprites.frontDefault,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      );
      expect(
        pokemon.sprites.backDefault,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png',
      );
    });
  });
}
