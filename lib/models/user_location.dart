import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'user_location.g.dart';

@JsonSerializable()
class UserLocation {
  String id;
  String? userId;
  String? coupleId;
  String? title;
  String? category;
  String? content;
  String? lat;
  String? lng;
  String? address;
  String? type;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserLocation({
    required this.id,
    this.userId,
    this.coupleId,
    this.title,
    this.category,
    this.content,
    this.lat,
    this.lng,
    this.address,
    this.type,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}
