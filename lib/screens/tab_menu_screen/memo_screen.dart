import 'package:flutter/material.dart';
import 'package:haedal/widgets/memo_group_widget.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: const [
        MemoGroupWidget(),
      ],
    ));
  }
}
