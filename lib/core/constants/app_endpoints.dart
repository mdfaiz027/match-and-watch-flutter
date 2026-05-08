class AppEndpoints {
  // TMDB
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbTrending = '/trending/movie/day';
  static const String tmdbMovieDetail = '/movie';
  static const String tmdbImageBaseW185 = 'https://image.tmdb.org/t/p/w185';
  static const String tmdbImageBaseW500 = 'https://image.tmdb.org/t/p/w500';

  // Reqres
  static const String reqresBaseUrl = 'https://reqres.in/api';
  static const String reqresUsers = '/users';

  // API Keys (Ideally these would be in a .env file, but for now we centralize them here or keep them in services)
  static const String tmdbApiKey = 'd3d9991864acd9b493f857b091ff97ed';
  static const String reqresApiKey = 'free_user_3DQl89b1wFD72BqXyUsTHQE9lGq';
}
