import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool isValid;
  final focusNode;
  final bool readOnly;
  final onTap;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.isValid = true,
      this.focusNode,
      this.readOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        onTap: onTap,
        decoration: InputDecoration(
            // isValid가 false면 에러메세지 아이콘
            prefixIcon:
                isValid ? null : const Icon(Icons.error, color: Colors.red),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
