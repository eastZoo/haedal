import 'package:flutter/material.dart';

class AnimationMarker extends StatelessWidget {
  final bool isMoving;

  const AnimationMarker({Key? key, required this.isMoving}) : super(key: key);

  get gradientColors => null;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 15),
              child: AnimatedOpacity(
                opacity: isMoving ? 0.5 : 1,
                duration: const Duration(milliseconds: 150),
                child: const MyMarker(),
              ),
            ),

            /// 그림자 및 높이 조절 위젯
            Transform.translate(
              offset: const Offset(0, 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(100, 50)),
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.1),
                    ],
                    radius: 1.2,
                  ),
                ),
                height: isMoving ? 6 : 3,
                width: isMoving ? 16 : 8,
                margin: EdgeInsets.only(
                  top: isMoving ? 16 : 0,
                  bottom: isMoving ? 16 + 48 : 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMarker extends StatelessWidget {
  const MyMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          scale: 1.5,
          image: AssetImage('assets/icons/target.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
