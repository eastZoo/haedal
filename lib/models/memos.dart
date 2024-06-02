import 'dart:ffi';

class Memos {
  final String id;
  final String userId;
  final String coupleId;
  final String memoCategoryId;
  final String memo;
  late final bool isDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Memos({
    required this.id,
    required this.userId,
    required this.coupleId,
    required this.memoCategoryId,
    required this.memo,
    this.isDone = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Add a factory method to create a FileData object from a Map
  factory Memos.fromJson(Map<String, dynamic> json) {
    return Memos(
      id: json['id'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      memoCategoryId: json['memoCategoryId'],
      memo: json['memo'],
      isDone: json['isDone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Memo {
  final String? id;
  final String? userId;
  final String? coupleId;
  final String? category;
  final String? title;
  final String? color;
  final int? clear;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Memos> memos;

  Memo({
    this.id,
    this.userId,
    this.coupleId,
    this.category,
    this.title,
    this.color,
    this.clear,
    this.createdAt,
    this.updatedAt,
    required this.memos,
  });

  // Add a factory method to create an Memos object from a Map
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      category: json['category'],
      title: json['title'],
      color: json['color'],
      clear: json['clear'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      memos: (json['memos'] as List<dynamic>)
          .map((file) => Memos.fromJson(file))
          .toList(),
    );
  }
}
