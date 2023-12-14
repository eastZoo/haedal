import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/app_style.dart';
import 'package:haedal/widgets/custom_switch.dart';
import 'package:haedal/widgets/date_time_widget.dart';
import 'package:haedal/widgets/my_textfield.dart';
import 'package:haedal/widgets/radio_widget.dart';
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
              Container(
                width: 50,
                height: 3,
                transformAlignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: Colors.grey.shade400,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.close,
                        size: 24,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const SizedBox(
                        width: 40,
                        child: Text(
                          "저장",
                          style: TextStyle(fontSize: 15),
                        )),
                  )
                ],
              ),
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
              const Text('Description', style: AppStyle.headingOne),
              const Gap(6),
              const TextFieldWidget(maxLine: 4, hintText: 'Add Descriptions'),
              const Gap(12),
              const Text('Category', style: AppStyle.headingOne),
              const Row(
                children: [
                  Expanded(
                    child: RadioWidget(
                        categColor: Colors.green, titleRadio: 'LRN'),
                  ),
                  Expanded(
                    child:
                        RadioWidget(categColor: Colors.blue, titleRadio: 'WRK'),
                  ),
                  Expanded(
                    child: RadioWidget(
                        categColor: Colors.amberAccent, titleRadio: 'Gen'),
                  )
                ],
              ),

              // 날짜 섹션
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateTimeWidget(
                    titleText: 'Date',
                    valueText: 'dd/mm/yy',
                    iconSection: CupertinoIcons.calendar,
                  ),
                  Gap(20),
                  DateTimeWidget(
                    titleText: 'Time',
                    valueText: 'hh : mm',
                    iconSection: CupertinoIcons.clock,
                  ),
                ],
              ),
              const Gap(10),
              // 버튼 섹션
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade800,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // RoundedRectangleBorder
                        side: BorderSide(
                          color: Colors.blue.shade800,
                        ), // BorderSide
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ), // ElevatedButton
                  ), // Expanded
                  const Gap(20),
                  Expanded(
                    child: Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ), // RoundedRectangleBorder
                          side: BorderSide(
                            color: Colors.blue.shade800,
                          ), // BorderSide
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        child: const Text('Create'),
                      ), // ElevatedButton
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
