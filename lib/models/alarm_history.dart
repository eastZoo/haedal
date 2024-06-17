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
  });

  factory AlarmHistory.fromJson(Map<String, dynamic> json) {
    return AlarmHistory(
      id: json['id'],
      alarmId: json['alarmId'],
      type: json['type'],
      picQty: json['pic_qty'],
      content: json['content'],
      crud: json['crud'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
