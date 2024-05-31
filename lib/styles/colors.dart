import 'package:flutter/material.dart';

///앱 컬러
class AppColors {
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();
  //custom color
  Color mainColor = const Color(0xFF6AADE1);
  Color mainYellowColor = const Color(0xFFFFF384);

  // original color
  Color white = const Color(0xFFFFFFFF);
  Color grey = const Color.fromARGB(255, 251, 252, 255);
  Color darkGrey = const Color(0xFF858585);
  Color lightGrey = const Color(0xFFDCDCDC);

  Color toDoGrey = const Color(0xFFF5F6FB);
  Color noticeRed = const Color.fromARGB(255, 255, 110, 110);

// original color text
  Color darkGreyText = const Color(0xFF858585);

  Color subContainer = const Color(0xFF8085FF);
  Color mainDisabledColor = const Color.fromARGB(255, 216, 206, 240);
}
