class EnvironmentConfig {
  static const SupabaseURL = String.fromEnvironment('SupabaseURL', defaultValue: '');

  static const SupabaseToken = String.fromEnvironment('SupabaseToken', defaultValue: '');
}
