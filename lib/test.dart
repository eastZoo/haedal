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
  List<Meeting>? appointments;

  @override
  State<ShowCurrentScheduleScreen> createState() =>
      _ShowCurrentScheduleScreenState(selectedDay, appointments);
}

class _ShowCurrentScheduleScreenState extends State<ShowCurrentScheduleScreen> {
  _ShowCurrentScheduleScreenState(this.selectedDay, this.appointments);
  DateTime? selectedDay;
  List<Meeting>? appointments;

  @override
  void initState() {
    super.initState();

    print("INIT!!!!!!");
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
    const textStyle = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            heightFactor: 0.7,
            child: Container(
              width: 50,
              height: 3,
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // 메인 타이틀 ( 요일 , 추가 아이콘 )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '${selectedDay?.month}월 '
          //       '${selectedDay?.day}일 '
          //       '${DateFormat('E', 'ko_KR').format(selectedDay!)}요일',
          //       style: textStyle,
          //     ),
          //     InkWell(
          //       onTap: () {
          //         _showAddCurrentDaySchedule();
          //       },
          //       child: const SizedBox(
          //         width: 40,
          //         child: Icon(
          //           Icons.add_circle,
          //           size: 28,
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          const SizedBox(height: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 56.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: appointments?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        width: 6,
                        height: 40,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// 