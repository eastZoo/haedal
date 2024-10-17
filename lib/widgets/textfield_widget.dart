import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.maxLine,
    required this.hintText,
    required this.controller,
    this.chosenColorCode, // 선택적으로 전달받는 색상 코드
  });

  final String hintText;
  final int maxLine;
  final TextEditingController controller;
  final String? chosenColorCode; // nullable String으로 설정

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 18,
          color: chosenColorCode != null
              ? Color(
                  int.parse("0xFF$chosenColorCode"), // 타이핑하는 텍스트의 색상
                )
              : null, // chosenColorCode가 null일 경우 기본 색상 사용
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 15),
        ),
        maxLines: maxLine,
      ),
    );
  }
}
