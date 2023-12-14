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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "캘린더",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFF676B85),
          ),
        ),
        leading: Icon(
          Icons.menu,
          size: 18,
          color: AppColors().mainColor,
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: const CalendarWidget(),
    );
  }
}
