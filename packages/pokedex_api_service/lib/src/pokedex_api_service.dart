import 'package:dio/dio.dart';
import 'package:pokedex_api_service/src/response/pokemon_detail_response.dart';
import 'package:pokedex_api_service/src/response/pokemon_list_response.dart';

class PokedexApiService {
  const PokedexApiService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<PokemonListResponse> getPokemonList({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );

      if (response.data == null) {
        throw Exception('Pokemon list is null');
      }
      return PokemonListResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception('Failed to load pokemon list: $e');
    }
  }

  Future<PokemonDetailResponse> getPokemonDetail({
    required String id,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon/$id',
      );

      if (response.data == null) {
        throw Exception('Pokemon detail is null');
      }

      return PokemonDetailResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception('Failed to load pokemon detail: $e');
    }
  }
}
