class Endpoints {
  Endpoints._();

  //production
  static const String villageUrl = "https://diabetes-village-api.insystem.kr";

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static const String visitMissionUrl = "$villageUrl/mission/visit";
  static const String userInfoUrl = "$villageUrl/user";
}
