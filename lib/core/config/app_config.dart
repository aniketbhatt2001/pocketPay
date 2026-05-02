import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for all environment-driven configuration.
///
/// Call [AppConfig.load] once in [main] before [runApp].
/// After that, every getter is safe to call from anywhere in the app.
class AppConfig {
  AppConfig._();

  /// Loads the `.env` file from the assets bundle.
  static Future<void> load() => dotenv.load(fileName: '.env');

  // ── Supabase ─────────────────────────────────────────────────────────────

  static String get supabaseUrl => _require('SUPABASE_URL');

  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  // ── Razorpay ─────────────────────────────────────────────────────────────

  static String get razorpayKeyId => _require('RAZORPAY_KEY_ID');

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns the value for [key], throwing a clear error if it is missing.
  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required environment variable "$key". '
        'Make sure it is defined in your .env file.',
      );
    }
    return value;
  }
}
