import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 날짜를 가져옵니다.
    DateTime now = DateTime.now();

    return Scaffold(
      body: Center(
        child: Text(
          '오늘의 날짜: ${now.year}년 ${now.month}월 ${now.day}일',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
