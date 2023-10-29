class CoupleConnectInfo {
  String id;
  String myId;
  String? partnerId;
  int code;
  DateTime? createdAt;
  DateTime? updatedAt;
  CoupleConnectInfo({
    required this.id,
    required this.myId,
    this.partnerId,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'myId': myId,
      'partnerId': partnerId,
      'code': code,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  factory CoupleConnectInfo.fromJson(Map<String, dynamic> json) {
    return CoupleConnectInfo(
      id: json['id'] as String,
      myId: json['myId'] as String,
      partnerId: json['partnerId'] != null ? json['partnerId'] as String : null,
      code: json['code'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
