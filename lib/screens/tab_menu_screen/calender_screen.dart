import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/calendar.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:haedal/widgets/main_appbar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            MainAppbar(title: '스토리 / 위치리스트'),
            // 달력 위젯
            CalendarWidget(),
          ],
        ),
      ),
    );
  }
}
