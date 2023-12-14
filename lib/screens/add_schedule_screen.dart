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
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    radius: 10,
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
                          style: TextStyle(fontSize: 17),
                        )),
                  )
                ],
              ),

              const Gap(12),
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
              const Text('메모', style: AppStyle.headingOne),
              const Gap(6),
              const TextFieldWidget(maxLine: 4, hintText: '메모를 적어주세요.'),
              const Gap(12),

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
            ],
          ),
        ),
      );
    });
  }
}
