import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
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

  ScheduleController scheduleCon = Get.put(ScheduleController());

  DateTime? selectedDay;
  List<Meeting>? appointments;

  @override
  void initState() {
    super.initState();
    print("init : $appointments");
  }

  _showAddCurrentDaySchedule() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.85,
          minChildSize: 0.8,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                body: AddScheduleScreen(selectedDay: selectedDay),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 20,
    );

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
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  var res = await _showAddCurrentDaySchedule();
                  // 추가버튼 눌렀다가 아무것도 안하고 뒤로오면 팝 말고 그냥 리턴
                  if (res == Null || res == null) {
                    return;
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const SizedBox(
                  width: 50,
                  height: 30,
                  child: Icon(
                    Icons.add_circle,
                    size: 28,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 56.0),
            child: appointments!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: appointments?.length,
                    itemBuilder: (context, index) {
                      print("COLOR !!${appointments![index].background}");
                      String startTime = DateFormat.Hm('ko_KR')
                          .format(appointments![index].from);

                      String endTime = DateFormat.Hm('ko_KR')
                          .format(appointments![index].to);
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // 왼쪽 라벨 색깔
                            Container(
                              decoration: BoxDecoration(
                                color: appointments![index].background,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              width: 6,
                              height: 54,
                            ),
                            // 라벨을 제외한 컨텐츠 박스
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 8, 8, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointments![index].eventName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          appointments![index].isAllDay
                                              ? const Text(
                                                  "종일",
                                                )
                                              : Text('$startTime - $endTime'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () async {
                                        print(appointments![index].id);
                                        var res = await scheduleCon
                                            .deleteCalendarItem(
                                                appointments![index].id);

                                        if (res) {
                                          await scheduleCon.refetchDataSource();
                                          Navigator.pop(context, true);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 23,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Center(
                      child: Text(
                        "등록된 일정이 없습니다.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
