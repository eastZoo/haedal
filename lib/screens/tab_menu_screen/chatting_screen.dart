import 'package:flutter/material.dart';
import 'package:haedal/widgets/main_appbar.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          MainAppbar(title: '채팅'),
        ],
      ),
    );
  }
}
