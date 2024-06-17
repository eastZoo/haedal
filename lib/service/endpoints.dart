import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  //production
  // static const String hostUrl = "http://192.168.45.156:3001";
  // static const String hostUrl = "http://221.162.130.113:3001";
  static final String hostUrl =
      dotenv.env['HOST_URL'] ?? 'http://default.url:3001';

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static String get authUrl => "$hostUrl/auth";
  static String get userInfoUrl => "$hostUrl/user";
  static String get boardUrl => "$hostUrl/album-board";
  static String get locationUrl => "$hostUrl/location";
  static String get caledarUrl => "$hostUrl/calendar";
  static String get memoUrl => "$hostUrl/memo";
  static String get alarmUrl => "$hostUrl/alarm-history";
}
