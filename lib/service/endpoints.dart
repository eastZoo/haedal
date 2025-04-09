import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  // .env 파일에서 HOST_URL 값을 가져옴
  static String get hostUrl =>
      dotenv.env['HOST_URL'] ?? "http://172.30.1.59:3001";

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
