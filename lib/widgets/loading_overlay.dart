import 'package:flutter/material.dart';

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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container();
    }
    return child;
  }
}
