import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool available;
  final double? fontSize;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Image? icon; // 새로운 icon 프로퍼티 추가

  const MyButton({
    super.key,
    required this.onTap,
    required this.title,
    this.available = false,
    this.fontSize = 14.0,
    this.height = 40,
    this.backgroundColor,
    this.textColor,
    this.icon, // icon 초기화
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: available
              ? (backgroundColor ?? AppColors().mainColor)
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!, // 아이콘이 있으면 추가
                const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
              ],
              Text(
                title,
                style: TextStyle(
                  color: available
                      ? (textColor ?? Colors.white)
                      : Colors.grey.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
