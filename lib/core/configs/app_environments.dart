import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironments {
  static String get fatsecretApiUrl => dotenv.env['FATSECRET_API_URL'] ?? '';
  static String get serverApiUrl => dotenv.env['SERVER_API_URL'] ?? '';
}
