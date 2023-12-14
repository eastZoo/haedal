import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:intl/intl.dart';

class ShowCurrentScheduleScreen extends StatefulWidget {
  ShowCurrentScheduleScreen(
      {super.key, required this.selectedDay, this.appointments});
  DateTime? selectedDay;
  dynamic appointments;

  @override
  State<ShowCurrentScheduleScreen> createState() =>
      _ShowCurrentScheduleScreenState(selectedDay, appointments);
}

class _ShowCurrentScheduleScreenState extends State<ShowCurrentScheduleScreen> {
  _ShowCurrentScheduleScreenState(this.selectedDay, this.appointments);
  DateTime? selectedDay;
  dynamic appointments;
  List<dynamic>? data;

  @override
  void initState() {
    super.initState();
    print(appointments);
    for (Meeting appointment in appointments) {
      // Do something with each Meeting instance

      print(appointment.eventName);
    }
  }

  _showAddCurrentDaySchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.7,
          minChildSize: 0.65,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: AddScheduleScreen(selectedDay: selectedDay),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    InfiniteScrollController infiniteCon = Get.put(InfiniteScrollController());
    CategoryBoardController categoryBoardCon =
        Get.put(CategoryBoardController());

    const textStyle = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20);

    return GetBuilder<MapController>(builder: (mapCon) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 3,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: Colors.grey.shade400,
                ),
              ),
              // 메인 타이틀 ( 요일 , 추가 아이콘 )
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedDay?.month}월 '
                    '${selectedDay?.day}일 '
                    '${DateFormat('E', 'ko_KR').format(selectedDay!)}요일',
                    style: textStyle,
                  ),
                  InkWell(
                    onTap: () {
                      _showAddCurrentDaySchedule();
                    },
                    child: const SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.add_circle,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),

              //일정 리스트 뷰
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    Meeting appointment = appointments[index];

                    if (appointments.isEmpty) {
                      return const Text("일정이 없습니다");
                    }

                    return postCard(appointment);
                  },
                  separatorBuilder: (_, index) => const Divider(),
                  itemCount: 3,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget postCard(Meeting? data) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text("${data?.eventName}"),
    );
  }
}
