import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('PokedexApiService', () {
    late Dio dio;
    late PokedexApiService apiService;

    setUp(() {
      dio = MockDio();
      apiService = PokedexApiService(dio: dio);
    });

    group('getPokemonList', () {
      test('returns PokemonListResponse when call is successful', () async {
        final responseData = {
          'count': 1,
          'next': null,
          'previous': null,
          'results': [
            {
              'name': 'bulbasaur',
              'url': 'https://pokeapi.co/api/v2/pokemon/1/',
            },
          ],
        };

        when(
          () => dio.get<Map<String, dynamic>>(
            '/pokemon',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/pokemon'),
          ),
        );

        final result = await apiService.getPokemonList();

        expect(result, isA<PokemonListResponse>());
        expect(result.count, equals(1));
        expect(result.results.length, equals(1));
        expect(result.results.first.name, equals('bulbasaur'));
      });

      test('throws Exception when call fails', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            '/pokemon',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/pokemon'),
            error: 'Something went wrong',
          ),
        );

        expect(
          () => apiService.getPokemonList(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getPokemonDetail', () {
      test('returns PokemonDetailResponse when call is successful', () async {
        final responseData = {
          'id': 1,
          'name': 'bulbasaur',
          'height': 7,
          'weight': 69,
          'types': [
            {
              'slot': 1,
              'type': {'name': 'grass', 'url': 'url'},
            },
          ],
          'sprites': {'front_default': 'url'},
        };

        when(() => dio.get<Map<String, dynamic>>('/pokemon/1')).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/pokemon/1'),
          ),
        );

        final result = await apiService.getPokemonDetail(id: '1');

        expect(result, isA<PokemonDetailResponse>());
        expect(result.id, equals(1));
        expect(result.name, equals('bulbasaur'));
      });

      test('throws Exception when call fails', () async {
        when(() => dio.get<Map<String, dynamic>>('/pokemon/1')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/pokemon/1'),
            error: 'Not found',
          ),
        );

        expect(
          () => apiService.getPokemonDetail(id: '1'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
