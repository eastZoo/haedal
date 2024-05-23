import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/screens/drawer_screen/custom_drawer.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:intl/intl.dart';

class TestScheduleScreen extends StatefulWidget {
  const TestScheduleScreen({super.key});

  @override
  State<TestScheduleScreen> createState() => _TestScheduleScreen();
}

class _TestScheduleScreen extends State<TestScheduleScreen> {
  @override
  void initState() {
    super.initState();

    print("INIT!!!!!!");
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20);

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Container(
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
            MyButton(
                onTap: () {
                  const storage = FlutterSecureStorage();
                  storage.delete(key: "accessToken");

                  print("GOOD");
                },
                title: "로그아웃",
                available: true),
          ],
        ),
      ),
    );
  }
}
// 