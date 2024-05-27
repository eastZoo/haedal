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
    if (isLoading) {
      return loadingAnimation
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors().mainColor,
              ),
            )
          : Container();
    }
    return child;
  }
}
