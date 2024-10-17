import 'dart:ui'; // 블러 효과를 위해 추가
import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool loadingAnimation;

  const LoadingOverlay({
    Key? key,
    this.isLoading = false,
    this.loadingAnimation = true,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // 기존 화면 내용
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2), // 블러 효과 추가
              child: Container(
                color: Colors.grey.withOpacity(0.2), // 반투명한 오버레이
                child: loadingAnimation
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors().mainColor,
                        ),
                      )
                    : Container(), // loadingAnimation이 false일 경우 빈 컨테이너
              ),
            ),
          ),
      ],
    );
  }
}
