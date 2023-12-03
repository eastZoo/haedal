import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'user_location.g.dart';

@JsonSerializable()
class UserLocation {
  int id;
  int? userId;
  String? title;
  double? lat;
  double? lng;
  String? address;
  String? type;
  String? description;
  DateTime? regTime;

  UserLocation({
    required this.id,
    this.userId,
    this.title,
    this.lat,
    this.lng,
    this.address,
    this.type,
    this.description,
    this.regTime,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}
