import 'package:flutter/material.dart';

///앱 컬러
class AppColors {
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();
  Color mainColor = const Color(0xFF674FA3);
  Color mainDisabledColor = const Color.fromARGB(255, 216, 206, 240);

  Color white = const Color(0xFFFFFFFF);

  Color subColor = const Color.fromARGB(255, 191, 171, 242);

  Color subContainer = const Color(0xFF8085FF);
  Color subContainer2 = const Color(0xff8fdb778);
  Color subContainer3 = const Color(0xFFDBB9FB);

  Color subContainerDisabled = const Color.fromARGB(255, 142, 148, 255);

  Color subContainerText = const Color(0xFF8C9DF8);
  Color statusWarning = const Color(0xFFFFA800);
  Color statusStop = const Color(0xFF3D3D3D);
  Color statusStart = const Color(0xFF10C257);
  Color detailColor = const Color(0xFFF6B100);
  Color blackButton = const Color(0xFF484848);
  Color borderColor = const Color(0xFFCFCFCF);
  Color blueColor = const Color(0xFF0072db);
  Color semiGrey = const Color(0xFF808080);
  Color textGrey = const Color.fromARGB(255, 157, 157, 157);
  Color backgroundColor = const Color(0xFFEEEEEE);
  Color red = const Color(0xFFFF4646);
  Color cancel = const Color(0xFF797979);
  Color buttonPrimary = const Color(0xFF6065F2);
  Color navy = const Color(0xFF1D22A8);
  Color appBarPrimary = const Color(0xFF676B85);
  LinearGradient mainGradient = const LinearGradient(
    colors: [
      Color(0xFF5C62F1),
      Color(0xFF7660FF),
    ],
  );
}
