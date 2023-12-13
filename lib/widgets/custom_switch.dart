import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final Function(bool value) onChanged;
  final bool value;
  final double trackWidth;
  final double trackHeight;
  final double toggleWidth;
  final double toggleHeight;
  final Color toggleActiveColor;
  final Color trackInActiveColor;
  final Color trackActiveColor;
  const CustomSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    this.trackHeight = 5,
    this.trackWidth = 20,
    this.toggleWidth = 10,
    this.toggleHeight = 10,
    this.trackActiveColor = const Color(0xffcccccc),
    this.trackInActiveColor = const Color(0xffcccccc),
    this.toggleActiveColor = const Color(0xff6385e6),
  });
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSwitched = !_isSwitched;
        });
      },
      child: SizedBox(
        width: widget.trackWidth,
        height: widget.toggleHeight > widget.trackHeight
            ? widget.toggleHeight
            : widget.trackHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.trackWidth,
              height: widget.trackHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: _isSwitched
                    ? widget.trackActiveColor
                    : widget.trackInActiveColor,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              left: _isSwitched ? 10.0 : 0.0,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    double newPosition = details.localPosition.dx;
                    if (newPosition < -15.0) {
                      newPosition = -15.0;
                    } else if (newPosition > 15.0) {
                      newPosition = 15.0;
                    }
                    _isSwitched = newPosition > 0.0;
                  });
                },
                child: Container(
                  width: widget.toggleWidth,
                  height: widget.toggleHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.toggleActiveColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
