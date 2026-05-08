class AppConstants {
  // Logic & System Constants
  static const String databaseName = 'app_database.sqlite';
  static const int pagedLimit = 20;
  
  // Animation Durations
  static const int durationFastMs = 200;
  static const int durationMediumMs = 300;
  static const int durationSlowMs = 500;
  static const int durationStaggerMs = 375;
  
  // Feature Specific
  static const int syncIntervalMinutes = 15;
  static const double networkFailureProbability = 0.3;
  static const int maxRetryAttempts = 3;
}
