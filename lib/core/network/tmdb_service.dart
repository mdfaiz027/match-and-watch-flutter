import 'package:dio/dio.dart';
import 'api_client.dart';

class TmdbService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  
  // Replace with your TMDB API Key
  static const String _apiKey = 'd3d9991864acd9b493f857b091ff97ed';

  TmdbService(this._apiClient);

  Future<Response> getTrendingMovies({int page = 1}) async {
    return _apiClient.dio.get(
      '$_baseUrl/trending/movie/day',
      queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      },
    );
  }

  Future<Response> getMovieDetails(int movieId) async {
    return _apiClient.dio.get(
      '$_baseUrl/movie/$movieId',
      queryParameters: {
        'api_key': _apiKey,
      },
    );
  }
}
