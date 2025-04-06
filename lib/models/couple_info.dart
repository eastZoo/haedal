class CoupleInfo {
  final Me? me;
  final Partner? partner;
  final CoupleData? coupleData;

  CoupleInfo({
    this.me,
    this.partner,
    this.coupleData,
  });

  // Add a factory method to create a CoupleInfo object from a Map
  factory CoupleInfo.fromJson(Map<String, dynamic> json) {
    return CoupleInfo(
      me: Me.fromJson(json['me']),
      partner: Partner.fromJson(json['partner']),
      coupleData: CoupleData.fromJson(json['coupleData']),
    );
  }
}

class Partner {
  final String? id;
  final String? name;
  final String? userEmail;
  final DateTime? birth;
  final int? age;
  final String? sex;
  final String? profileUrl;
  final String? emotion;
  final int? connectState;

  Partner({
    this.id,
    this.name,
    this.userEmail,
    this.birth,
    this.age,
    this.sex,
    this.profileUrl,
    this.emotion,
    this.connectState,
  });

  // Add a factory method to create a Partner object from a Map
  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] != null ? json["id"] as String : null,
      name: json['name'] != null ? json["name"] as String : null,
      userEmail: json['userEmail'] != null ? json["userEmail"] as String : null,
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      age: json['age'] != null ? json['age'] as int : null,
      sex: json['sex'] != null ? json["userEmail"] as String : null,
      profileUrl:
          json['profileUrl'] != null ? json["profileUrl"] as String : null,
      emotion: json['emotion'] != null ? json["emotion"] as String : null,
      connectState:
          json['connectState'] != null ? json['connectState'] as int : null,
    );
  }
}

class Me {
  final String? id;
  final String? name;
  final String? userEmail;
  final DateTime? birth;
  final int? age;
  final String? sex;
  final String? profileUrl;
  final String? emotion;
  final int? connectState;

  Me({
    this.id,
    this.name,
    this.userEmail,
    this.birth,
    this.age,
    this.sex,
    this.profileUrl,
    this.emotion,
    this.connectState,
  });

  // Add a factory method to create a User object from a Map
  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json['id'] != null ? json["id"] as String : null,
      name: json['name'] != null ? json["name"] as String : null,
      userEmail: json['userEmail'] != null ? json["userEmail"] as String : null,
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      age: json['age'] != null ? json['age'] as int : null,
      sex: json['sex'] != null ? json["sex"] as String : null,
      profileUrl:
          json['profileUrl'] != null ? json["profileUrl"] as String : null,
      emotion: json['emotion'] != null ? json["emotion"] as String : null,
      connectState:
          json['connectState'] != null ? json['connectState'] as int : null,
    );
  }
}

class CoupleData {
  final String? id;
  final DateTime? firstDay;
  final String? homeProfileUrl;
  CoupleData({
    this.id,
    this.firstDay,
    this.homeProfileUrl,
  });

  // Add a factory method to create a CoupleData object from a Map
  factory CoupleData.fromJson(Map<String, dynamic> json) {
    return CoupleData(
      id: json['id'] != null ? json["id"] as String : null,
      firstDay:
          json['firstDay'] != null ? DateTime.parse(json['firstDay']) : null,
      homeProfileUrl: json['homeProfileUrl'] != null
          ? json["homeProfileUrl"] as String
          : null,
    );
  }

  // Add a method to convert a CoupleData object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstDay': firstDay?.toIso8601String(),
      'homeProfileUrl': homeProfileUrl,
    };
  }
}
