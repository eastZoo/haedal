import 'package:flutter/material.dart';
import 'package:haedal/widgets/main_appbar.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          MainAppbar(title: '메모'),
        ],
      ),
    );
  }
}
