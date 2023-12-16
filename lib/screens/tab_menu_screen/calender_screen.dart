import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:haedal/widgets/main_appbar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key, required this.controller});

  final CalendarController controller;
  @override
  State<CalenderScreen> createState() => _CalenderScreenState(controller);
}

class _CalenderScreenState extends State<CalenderScreen> {
  _CalenderScreenState(this.controller);
  CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
        init: ScheduleController(),
        builder: (ScheduleCon) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  const MainAppbar(title: '스토리 / 위치리스트'),
                  // 달력 위젯
                  CalendarWidget(
                    controller: controller,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
