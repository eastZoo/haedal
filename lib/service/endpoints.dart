class Endpoints {
  Endpoints._();

  //production
  static const String hostUrl = "http://localhost:3001";

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static const String authUrl = "$hostUrl/auth";
  static const String userInfoUrl = "$hostUrl/user";
}
