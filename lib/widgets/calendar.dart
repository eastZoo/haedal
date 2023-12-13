import 'package:flutter/material.dart';
import 'package:haedal/screens/show_current_schedule_screen.dart';
import 'package:haedal/screens/select_photo_options_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:haedal/styles/colors.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
  _showCurrentDaySchedule() {
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
            return SingleChildScrollView(
              controller: scrollController,
              child: ShowCurrentScheduleScreen(selectedDay: selectedDay),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey[200],
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      // 언어를 한글로 설정 (포스팅 아래 내용 확인 -> intl 라이브러리 )
      locale: 'ko_KR',
      // 포커싱 날짜 (오늘 날짜를 기준으로 함)
      focusedDay: focusedDay,
      // 최소 년도
      firstDay: DateTime(1997),
      // 최대 년도
      lastDay: DateTime(2100),
      headerStyle: const HeaderStyle(
        // default로 설정 돼 있는 2 weeks 버튼을 없애줌 (아마 2주단위로 보기 버튼인듯?)
        formatButtonVisible: false,
        // 달력 타이틀을 센터로
        titleCentered: true,
        // 말 그대로 타이틀 텍스트 스타일링
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors().mainColor,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          // 오늘 날짜에 하이라이팅의 유무
          isTodayHighlighted: true,
          // 캘린더의 평일 배경 스타일링(default면 평일을 의미)
          defaultDecoration: defaultBoxDeco,
          // 캘린더의 주말 배경 스타일링
          weekendDecoration: defaultBoxDeco,
          // 선택한 날짜 배경 스타일링
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: AppColors().mainColor,
              width: 1.0,
            ),
          ),

          // 기본 값이 BoxShape.circle로 돼 있는데 우리는 rectangle로 해 줄 예정
          // 만약 여기 설정을 해주지 않는다면 기본 설정인 circle과 우리의 설정인 rectangle이 겹쳐서 에러가 발생
          outsideDecoration: const BoxDecoration(shape: BoxShape.rectangle),
          // 텍스트 스타일링들
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle:
              defaultTextStyle.copyWith(color: AppColors().mainColor)),
      // 원하는 날짜 클릭 시 이벤트
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        // 클릭 할 때 state를 변경
        setState(() {
          prevSelectedDay = this.selectedDay;
          this.selectedDay = selectedDay;
          // 우리가 달력 내에서 전 달 날짜를 클릭 할 때 옮겨주도록 state를 변경시켜 줌
          this.focusedDay = selectedDay;
        });
        print("prevSelectedDay : $prevSelectedDay");
        print("selectedDay : $selectedDay");

        if (prevSelectedDay == selectedDay) {
          _showCurrentDaySchedule();
        }
      },

      // selectedDayPredicate를 통해 해당 날짜가 맞는지 비교 후 true false 비교 후 반환해 줌
      selectedDayPredicate: (DateTime date) {
        if (selectedDay == null) {
          return false;
        }

        return date.year == selectedDay!.year &&
            date.month == selectedDay!.month &&
            date.day == selectedDay!.day;
      },
    );
  }
}
