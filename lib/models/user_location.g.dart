// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      lat: json['lat'] as double?,
      lng: json['lng'] as double,
      address: json['address'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      regTime: json['regTime'] == null
          ? null
          : DateTime.parse(json['regTime'] as String),
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'type': instance.type,
      'description': instance.description,
      'regTime': instance.regTime?.toIso8601String(),
    };
