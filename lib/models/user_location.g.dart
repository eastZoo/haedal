// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      coupleId: json['coupleId'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      content: json['content'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String,
      address: json['address'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'coupleId': instance.coupleId,
      'title': instance.title,
      'category': instance.category,
      'content': instance.content,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'type': instance.type,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
