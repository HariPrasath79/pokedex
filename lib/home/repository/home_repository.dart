import 'package:dio/dio.dart';
import 'package:pokedex/home/models/pokemon.dart';

class HomeRepository {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  final Dio dio = Dio();

  Future<List<Pokemon>> fetchPokemons(int offset, int limit) async {
    final response = await dio
        .get(baseUrl, queryParameters: {'offset': offset, 'limit': limit});

    if (response.statusCode == 200) {
      final data = response.data;
      final List results = data['results'];
      return results.map((e) => Pokemon.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch Pokémon list');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonImage(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Failed to fetch Pokémon image');
    }
  }
}
