import 'package:haedal/models/couple_info.dart';

class AlarmHistory {
  final int id;
  final String alarmId;
  final String type;
  final int? picQty;
  final String content;
  final String crud;
  final String userId;
  final String coupleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  AlarmHistory({
    required this.id,
    required this.alarmId,
    required this.type,
    this.picQty,
    required this.content,
    required this.crud,
    required this.userId,
    required this.coupleId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory AlarmHistory.fromJson(Map<String, dynamic> json) {
    return AlarmHistory(
      id: json['id'],
      alarmId: json['alarmId'],
      type: json['type'],
      picQty: json['pic_qty'] != null ? json['pic_qty'] as int : null,
      content: json['content'],
      crud: json['crud'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final String? name;
  final String? profileUrl;

  User({
    required this.name,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String?,
      profileUrl: json['profileUrl'] as String?,
    );
  }
}
