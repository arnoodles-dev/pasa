import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/helpers/extensions/string_ext.dart';

final class AppConfig {
  static Env get environment => switch (dotenv.get('ENV')) {
        'Development' => Env.development,
        'Staging' => Env.staging,
        'Production' => Env.production,
        _ => Env.development
      };
  static String get baseApiUrl => dotenv.get('BASE_API_URL');
  static String get supabaseUrl => dotenv.get('SUPABASE_URL');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');
  static bool get enableCrashlytics =>
      dotenv.get('ENABLE_CRASHLYTICS').toBoolean;
  static bool get enablePerformanceMonitor =>
      dotenv.get('ENABLE_PERFORMANCE_MONITOR').toBoolean;
  static bool get enableAnalytics => dotenv.get('ENABLE_ANALYTICS').toBoolean;
  static String get iosAuthClientId => dotenv.get('IOS_AUTH_CLIENT_ID');
  static String get webAuthClientId => dotenv.get('WEB_AUTH_CLIENT_ID');
}
