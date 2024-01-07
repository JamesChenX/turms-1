class EnvVars {
  EnvVars._();

  static const bool databaseLogStatements = bool.fromEnvironment('DATABASE_LOG_STATEMENTS');
  static const String giphyApiKey = String.fromEnvironment('GIPHY_API_KEY');
  static const bool secureStorage = bool.fromEnvironment('SECURE_STORAGE');
  static const String windowTitle = String.fromEnvironment('WINDOW_TITLE');
  static const bool showFocusTracker = bool.fromEnvironment('SHOW_FOCUS_TRACKER');
}