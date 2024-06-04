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
      id: json['id'] as String?,
      name: json['name'] as String?,
      userEmail: json['userEmail'] as String?,
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      age: json['age'] != null ? json['age'] as int : null,
      sex: json['sex'] as String?,
      profileUrl: json['profileUrl'] as String?,
      emotion: json['emotion'] as String?,
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
      id: json['id'] as String?,
      name: json['name'] as String?,
      userEmail: json['userEmail'] as String?,
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      age: json['age'] != null ? json['age'] as int : null,
      sex: json['sex'] as String?,
      profileUrl: json['profileUrl'] as String?,
      emotion: json['emotion'] as String?,
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
      id: json['id'],
      firstDay: DateTime.parse(json['firstDay']),
      homeProfileUrl: json['homeProfileUrl'],
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
