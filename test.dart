import 'package:flutter/material.dart';

class AnimationMarker extends StatelessWidget {
  final bool isMoving;

  const AnimationMarker({Key? key, required this.isMoving}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: isMoving ? 10.0 : 0.0),
      decoration: BoxDecoration(
        color: isMoving ? Colors.transparent : Colors.red,
        boxShadow: isMoving
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ]
            : [],
      ),
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: isMoving ? Colors.transparent : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
