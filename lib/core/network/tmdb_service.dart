import 'package:dio/dio.dart';
import 'api_client.dart';

class TmdbService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  
  // Placeholder for API Key. Use --dart-define=TMDB_API_KEY=your_key or a constants file in production.
  static const String _apiKey = 'YOUR_TMDB_API_KEY_HERE';

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
