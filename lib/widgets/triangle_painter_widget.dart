import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xffFFC2C2)
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width, 0); // Start at the top right
    path.lineTo(size.width, size.height); // Draw line to the bottom right

    path.lineTo(0, 0); // Draw line to the top left
    path.close(); // Complete the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
