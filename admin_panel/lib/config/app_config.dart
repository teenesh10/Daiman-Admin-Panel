// import 'package:flutter/foundation.dart'; // Not needed for current implementation

class AppConfig {
  // Default values for development (these should be replaced with environment variables in production)
  static const String _defaultApiKey = "AIzaSyDVsO30_Q_pOHrD4F0BHBBb_yTuk31oByI";
  static const String _defaultProjectId = "fyp-daiman";
  static const String _defaultMessagingSenderId = "95968883140";
  static const String _defaultAppId = "1:95968883140:web:2aed2205203908b3f3b491";
  static const String _defaultFunctionsUrl = "https://us-central1-fyp-daiman.cloudfunctions.net";
  
  // Firebase Configuration
  static String get firebaseApiKey {
    // In production, this should be loaded from environment variables
    return const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: _defaultApiKey);
  }
  
  static String get firebaseProjectId {
    return const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: _defaultProjectId);
  }
  
  static String get firebaseMessagingSenderId {
    return const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: _defaultMessagingSenderId);
  }
  
  static String get firebaseAppId {
    return const String.fromEnvironment('FIREBASE_APP_ID', defaultValue: _defaultAppId);
  }
  
  // Firebase Functions URL
  static String get firebaseFunctionsUrl {
    return const String.fromEnvironment('FIREBASE_FUNCTIONS_URL', defaultValue: _defaultFunctionsUrl);
  }
  
  // Environment
  static String get environment {
    return const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  }
  
  // Check if running in production
  static bool get isProduction => environment == 'production';
  
  // Check if running in development
  static bool get isDevelopment => environment == 'development';
  
  // Security: Hide sensitive information in production
  static String get maskedApiKey {
    if (isProduction) {
      return '***masked***';
    }
    return firebaseApiKey;
  }
  
  // Security: Hide project ID in production logs
  static String get maskedProjectId {
    if (isProduction) {
      return '***masked***';
    }
    return firebaseProjectId;
  }
}
