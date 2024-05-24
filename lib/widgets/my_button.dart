import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool available;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.available = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: available ? AppColors().mainColor : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: available ? Colors.white : Colors.grey.shade300,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
