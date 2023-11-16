import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  /// 가로 길이
  // final double width;

  /// 세로 길이
  // final double height;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final String text;
  final double width;
  final double height;
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final BorderSide? side;
  final Icon? icon;
  final Size? minimumSize;

  const AppButton(
      {Key? key,
      this.width = 90,
      this.height = 50,
      this.text = "",
      this.child,
      this.onPressed,
      this.color = Colors.black,
      this.textColor = Colors.white,
      this.radiusTopLeft = 7.0,
      this.radiusTopRight = 7.0,
      this.radiusBottomLeft = 7.0,
      this.radiusBottomRight = 7.0,
      this.side,
      this.icon,
      this.minimumSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        disabledBackgroundColor: Colors.grey.shade300,
        minimumSize: minimumSize,
        maximumSize: Size(width, height),
        backgroundColor: color,
        side: side,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radiusTopLeft),
            topRight: Radius.circular(radiusTopRight),
            bottomLeft: Radius.circular(radiusBottomLeft),
            bottomRight: Radius.circular(radiusBottomRight),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (icon != null) icon!,
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.apply(color: textColor, fontWeightDelta: 2),
          ),
        ],
      ),
    );
  }
}
