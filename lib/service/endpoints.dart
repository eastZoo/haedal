class Endpoints {
  Endpoints._();

  //production
  // static const String hostUrl = "http://192.168.0.75:3001";
  // static const String hostUrl = "http://192.168.45.11:3001";
  static const String hostUrl = "http://eastzoo.synology.me:3001";

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static const String authUrl = "$hostUrl/auth";
  static const String userInfoUrl = "$hostUrl/user";
  static const String boardUrl = "$hostUrl/album-board";
  static const String locationUrl = "$hostUrl/location";
  static const String caledarUrl = "$hostUrl/calendar";
  static const String memoUrl = "$hostUrl/memo";
}
