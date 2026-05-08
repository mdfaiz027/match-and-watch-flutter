import 'package:dio/dio.dart';
import 'api_client.dart';

class OmdbService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://www.omdbapi.com/';
  
  // Replace with your OMDB API Key
  static const String _apiKey = '?i=tt3896198&apikey=7923ea8f';

  OmdbService(this._apiClient);

  Future<Response> searchMovies({required String query, int page = 1}) async {
    return _apiClient.dio.get(
      _baseUrl,
      queryParameters: {
        'apikey': _apiKey,
        's': query,
        'page': page,
        'type': 'movie',
      },
    );
  }

  Future<Response> getMovieDetails(String imdbId) async {
    return _apiClient.dio.get(
      _baseUrl,
      queryParameters: {
        'apikey': _apiKey,
        'i': imdbId,
        'plot': 'full',
      },
    );
  }
}
