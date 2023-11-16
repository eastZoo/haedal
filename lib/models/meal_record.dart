import 'package:haedal/models/foods.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_record.g.dart';

@JsonSerializable()
class MealRecord {
  int? id;
  String? userId;
  DateTime? beforeTime;
  String? beforeImg1;
  String? beforeImg2;
  String? beforeImg3;
  String? beforeImg4;
  String? beforeImg5;
  String? beforeRemark;
  DateTime? afterTime;
  String? afterImg1;
  String? afterImg2;
  String? afterImg3;
  String? afterImg4;
  String? afterImg5;
  String? afterRemark;
  List<Foods>? foodInfo;
  DateTime? regTime;

  MealRecord({
    this.id,
    this.userId,
    this.beforeTime,
    this.beforeImg1,
    this.beforeImg2,
    this.beforeImg3,
    this.beforeImg4,
    this.beforeImg5,
    this.beforeRemark,
    this.afterTime,
    this.afterImg1,
    this.afterImg2,
    this.afterImg3,
    this.afterImg4,
    this.afterImg5,
    this.afterRemark,
    this.foodInfo,
    this.regTime,
  });

  factory MealRecord.fromJson(Map<String, dynamic> json) =>
      _$MealRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MealRecordToJson(this);
}
