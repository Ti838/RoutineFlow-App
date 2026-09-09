enum Environment { dev, staging, prod }

class AppConfig {
  static const String appName = 'Routine Flow';
  static const String appTagline = 'Personal Routine + University Routine = One Unified Daily Schedule';
  static const String version = '1.0.0';
  
  static Environment environment = Environment.dev;

  static String get apiBaseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://dev-api.routineflow.app/api/v1';
      case Environment.staging:
        return 'https://staging-api.routineflow.app/api/v1';
      case Environment.prod:
        return 'https://api.routineflow.app/api/v1';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
