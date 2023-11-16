// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealRecord _$MealRecordFromJson(Map<String, dynamic> json) => MealRecord(
      id: json['id'] as int?,
      userId: json['userId'] as String?,
      beforeTime: json['beforeTime'] == null
          ? null
          : DateTime.parse(json['beforeTime'] as String),
      beforeImg1: json['beforeImg1'] as String?,
      beforeImg2: json['beforeImg2'] as String?,
      beforeImg3: json['beforeImg3'] as String?,
      beforeImg4: json['beforeImg4'] as String?,
      beforeImg5: json['beforeImg5'] as String?,
      beforeRemark: json['beforeRemark'] as String?,
      afterTime: json['afterTime'] == null
          ? null
          : DateTime.parse(json['afterTime'] as String),
      afterImg1: json['afterImg1'] as String?,
      afterImg2: json['afterImg2'] as String?,
      afterImg3: json['afterImg3'] as String?,
      afterImg4: json['afterImg4'] as String?,
      afterImg5: json['afterImg5'] as String?,
      afterRemark: json['afterRemark'] as String?,
      foodInfo: (json['foodInfo'] as List<dynamic>?)
          ?.map((e) => Foods.fromJson(e as Map<String, dynamic>))
          .toList(),
      regTime: json['regTime'] == null
          ? null
          : DateTime.parse(json['regTime'] as String),
    );

Map<String, dynamic> _$MealRecordToJson(MealRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'beforeTime': instance.beforeTime?.toIso8601String(),
      'beforeImg1': instance.beforeImg1,
      'beforeImg2': instance.beforeImg2,
      'beforeImg3': instance.beforeImg3,
      'beforeImg4': instance.beforeImg4,
      'beforeImg5': instance.beforeImg5,
      'beforeRemark': instance.beforeRemark,
      'afterTime': instance.afterTime?.toIso8601String(),
      'afterImg1': instance.afterImg1,
      'afterImg2': instance.afterImg2,
      'afterImg3': instance.afterImg3,
      'afterImg4': instance.afterImg4,
      'afterImg5': instance.afterImg5,
      'afterRemark': instance.afterRemark,
      'foodInfo': instance.foodInfo,
      'regTime': instance.regTime?.toIso8601String(),
    };
