import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEndpoints {
  // Base URLs
  static const String baseUrlTmdb = 'https://api.themoviedb.org/3';
  static const String baseUrlReqres = 'https://reqres.in/api';

  // Paths
  static const String trendingMovies = '/trending/movie/day';
  static const String movieDetails = '/movie';
  static const String usersList = '/users';

  // Images
  static const String tmdbImageBaseW185 = 'https://image.tmdb.org/t/p/w185';
  static const String tmdbImageBaseW500 = 'https://image.tmdb.org/t/p/w500';

  // Computed Endpoints
  static String get tmdbTrendingUrl => '$baseUrlTmdb$trendingMovies';
  static String get tmdbDetailsUrl => '$baseUrlTmdb$movieDetails';
  static String get reqresUsersUrl => '$baseUrlReqres$usersList';

  // API Keys from Environment
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get reqresApiKey => dotenv.env['REQRES_API_KEY'] ?? '';
}
