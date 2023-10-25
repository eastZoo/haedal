import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool disabled;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.disabled = true});

  @override
  Widget build(BuildContext context) {
    print('@@@@@@@@@@@: $disabled');
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade400 : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: disabled ? Colors.grey.shade300 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
