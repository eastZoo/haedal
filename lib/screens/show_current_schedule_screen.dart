import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/utils/toast.dart';
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

  // 현재 날짜에 일정 추가하는 모달창
  Future<void> _navigateToAddSchedulePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => AddScheduleScreen(selectedDay: selectedDay),
      ),
    );

    if (result != null && result == true) {
      await scheduleCon.refetchDataSource(); // 데이터 리패칭

      // 현재 선택된 날짜의 일정만 필터링
      appointments = scheduleCon.meetings.where((meeting) {
        return meeting.from.year == selectedDay!.year &&
            meeting.from.month == selectedDay!.month &&
            meeting.from.day == selectedDay!.day;
      }).toList();

      setState(() {}); // UI 업데이트
      CustomToast().alert("일정이 추가되었습니다.", type: 'success');
    }
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
      color: Colors.white,
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
                  await _navigateToAddSchedulePage();
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
            constraints: const BoxConstraints(minHeight: 400),
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
                      //  투두 아이템 위젯
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        width: double.infinity,
                        height: 65,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
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
                              height: 65,
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
                                          20, 10, 8, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointments![index].eventName,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(2.5),
                                          appointments![index].isAllDay
                                              ? const Text(
                                                  "종일",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              : Text(
                                                  '$startTime - $endTime',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
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
                : Center(
                    child: Center(
                      child: Text(
                        "등록된 일정이 없습니다.",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
