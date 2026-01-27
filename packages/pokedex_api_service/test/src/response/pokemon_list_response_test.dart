import 'package:pokedex_api_service/src/response/pokemon_list_response.dart';
import 'package:test/test.dart';

void main() {
  group('PokemonListItemResponse', () {
    test('fromJson parses correctly', () {
      final json = <String, dynamic>{
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/',
      };
      final response = PokemonListItemResponse.fromJson(json);
      expect(response.name, 'bulbasaur');
      expect(response.url, 'https://pokeapi.co/api/v2/pokemon/1/');
    });

    group('id', () {
      test('extracts id from url with trailing slash', () {
        const response = PokemonListItemResponse(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/pokemon/1/',
        );
        expect(response.id, '1');
      });

      test('extracts id from url without trailing slash', () {
        const response = PokemonListItemResponse(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/pokemon/1',
        );
        expect(response.id, '1');
      });

      test('extracts id from url with extra segments', () {
        const response = PokemonListItemResponse(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/type/12/',
        );
        expect(response.id, '12');
      });
    });
  });

  group('PokemonListResponse', () {
    test('fromJson parses correctly', () {
      final json = <String, dynamic>{
        'count': 1281,
        'next': 'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
        'previous': null,
        'results': [
          {
            'name': 'bulbasaur',
            'url': 'https://pokeapi.co/api/v2/pokemon/1/',
          },
        ],
      };
      final response = PokemonListResponse.fromJson(json);
      expect(response.count, 1281);
      expect(
        response.next,
        'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
      );
      expect(response.previous, isNull);
      expect(response.results, hasLength(1));
      expect(response.results.first.name, 'bulbasaur');
    });
  });
}
