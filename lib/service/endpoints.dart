import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  //production
  // static const String hostUrl = "http://192.168.0.75:3001";
  // static const String hostUrl = "http://172.30.1.44:3001";
  static const String hostUrl = "http://haedal-api.components.kr";

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
