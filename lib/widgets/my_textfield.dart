import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool isValid;
  final focusNode;
  final bool readOnly;
  final onTap;
  final double height;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.isValid = true,
      this.focusNode,
      this.readOnly = false,
      this.onTap,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        onTap: onTap,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),

            // isValid가 false면 에러메세지 아이콘
            prefixIcon:
                isValid ? null : const Icon(Icons.error, color: Colors.red),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors().mainColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors().mainYellowColor),
            ),
            fillColor: AppColors().white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors().mainColor, fontSize: 14)),
      ),
    );
  }
}
