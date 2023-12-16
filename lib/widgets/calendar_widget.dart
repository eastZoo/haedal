import 'package:flutter/material.dart';

import 'package:haedal/screens/show_current_schedule_screen.dart';
import 'package:haedal/screens/select_photo_options_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:haedal/styles/colors.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.controller});
  final CalendarController controller;
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState(controller);
}

class _CalendarWidgetState extends State<CalendarWidget> {
  _CalendarWidgetState(this.controller);

  CalendarController controller;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  DateTime? prevSelectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = focusedDay;
  }

  // 달력 날짜 두번 탭 시 슬라이드업 패널
  _showCurrentDaySchedule(List<Meeting> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.8,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return ShowCurrentScheduleScreen(
                selectedDay: selectedDay, appointments: appointment);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource()),
        controller: controller,
        // 달력 뷰 세팅
        headerStyle: const CalendarHeaderStyle(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        showNavigationArrow: true,
        appointmentTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Pretendard',
          color: Colors.white,
        ),
        allowAppointmentResize: true,
        monthViewSettings: MonthViewSettings(
          // 달력에 있는 일정 표시 방법 ( 점 , 타이틀 )
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 4,
          // 밑에 클릭 시 설명
          // showAgenda: true,
          // 아래 설명 창 높이
          // agendaViewHeight: 180,
          // 달력 스타일 설정
          monthCellStyle: MonthCellStyle(
              // 달력 날짜 사이즈 설정
              textStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              // 이전날짜
              trailingDatesTextStyle: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                fontFamily: 'Pretendard',
                color: Colors.grey.shade400,
              ),
              // 이후날짜
              leadingDatesTextStyle: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                fontFamily: 'Pretendard',
                color: Colors.grey.shade400,
              )),
        ),
        todayTextStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Pretendard',
        ),
        onTap: (CalendarTapDetails details) async {
          dynamic appointments = details.appointments;
          DateTime selectedDay = details.date!;
          final List<Meeting> meetings = <Meeting>[];
          setState(
            () {
              prevSelectedDay = this.selectedDay;
              this.selectedDay = selectedDay;
            },
          );

          for (Meeting item in appointments) {
            meetings.add(Meeting(item.eventName, item.from, item.to,
                AppColors().mainColor, item.isAllDay));
          }

          if (prevSelectedDay == selectedDay) {
            await _showCurrentDaySchedule(meetings);
          }
        },
      ),
    );
  }
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting('데이투', startTime, endTime, AppColors().mainColor, true));
  meetings.add(Meeting('뭐할까', startTime, endTime, AppColors().subColor, false));
  meetings.add(Meeting('밥약속', startTime, endTime, AppColors().mainColor, true));

  meetings.add(Meeting('수련회', DateTime(2023, 12, 12, 13, 12, 11),
      DateTime(2023, 12, 12, 15, 12, 11), AppColors().mainColor, false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
