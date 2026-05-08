import 'package:dio/dio.dart';
import 'api_client.dart';
import '../constants/app_endpoints.dart';

class TmdbService {
  final ApiClient _apiClient;

  TmdbService(this._apiClient);

  Future<Response> getTrendingMovies({int page = 1}) async {
    return _apiClient.dio.get(
      '${AppEndpoints.tmdbBaseUrl}${AppEndpoints.tmdbTrending}',
      queryParameters: {
        'api_key': AppEndpoints.tmdbApiKey,
        'language': 'en-US',
        'page': page,
      },
    );
  }

  Future<Response> getMovieDetails(int movieId) async {
    return _apiClient.dio.get(
      '${AppEndpoints.tmdbBaseUrl}${AppEndpoints.tmdbMovieDetail}/$movieId',
      queryParameters: {
        'api_key': AppEndpoints.tmdbApiKey,
      },
    );
  }
}
