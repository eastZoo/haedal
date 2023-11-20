class Endpoints {
  Endpoints._();

  //production
  // static const String hostUrl = "http://192.168.0.75:3001";
  static const String hostUrl = "http://172.30.1.44:3001";
  // static const String hostUrl = "http://eastzoo.synology.me:3001";

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static const String authUrl = "$hostUrl/auth";
  static const String userInfoUrl = "$hostUrl/user";
  static const String imageUrl = "$hostUrl/album-board";
}
