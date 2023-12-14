import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/app_style.dart';
import 'package:haedal/widgets/custom_switch.dart';
import 'package:haedal/widgets/my_textfield.dart';
import 'package:haedal/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

class AddScheduleScreen extends StatefulWidget {
  DateTime? selectedDay;
  AddScheduleScreen({super.key, required this.selectedDay});

  @override
  State<AddScheduleScreen> createState() =>
      _AddScheduleScreenState(selectedDay);
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  _AddScheduleScreenState(this.selectedDay);
  DateTime? selectedDay;
  bool isSwitched = false;
  TextEditingController titleTextController = TextEditingController();

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    InfiniteScrollController infiniteCon = Get.put(InfiniteScrollController());
    CategoryBoardController categoryBoardCon =
        Get.put(CategoryBoardController());

    double width = MediaQuery.of(context).size.width;

    const textStyle = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20);

    return GetBuilder<MapController>(builder: (mapCon) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: 50,
              //   height: 3,
              //   transformAlignment: Alignment.center,
              //   margin: const EdgeInsets.only(bottom: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(2.5),
              //     color: Colors.grey.shade400,
              //   ),
              // ),
              // 앱바
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () {},
              //       child: const SizedBox(
              //         width: 40,
              //         child: Icon(
              //           Icons.close,
              //           size: 24,
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {},
              //       child: const SizedBox(
              //           width: 40,
              //           child: Text(
              //             "저장",
              //             style: TextStyle(fontSize: 15),
              //           )),
              //     )
              //   ],
              // ),
              const Gap(20),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "일정 등록",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Divider(
                thickness: 1.2,
                color: Colors.grey.shade300,
              ),
              const Gap(6),
              // 제목
              const Text(
                "할 일",
                style: AppStyle.headingOne,
                textAlign: TextAlign.end,
              ),
              const Gap(6),
              const TextFieldWidget(
                maxLine: 1,
                hintText: "Title",
              ),
              const Gap(6),
              const TextFieldWidget(maxLine: 1, hintText: 'Add Task Name'),
              const Gap(12),
              const Text('Description', style: AppStyle.headingOne),
              const Gap(6),
              const TextFieldWidget(maxLine: 5, hintText: 'Add Descriptions'),
              const Gap(12),
              const Text('Category', style: AppStyle.headingOne),
              RadioListTile(value: 1, groupValue: 0, onChanged: (value) {})
            ],
          ),
        ),
      );
    });
  }
}
