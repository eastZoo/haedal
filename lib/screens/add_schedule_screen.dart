import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/widgets/custom_switch.dart';
import 'package:haedal/widgets/my_textfield.dart';
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
            children: [
              Container(
                width: 50,
                height: 3,
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
              // 제목
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.9,
                    child: renderTextFormField(
                      hintText: "제목",
                      controller: titleTextController,
                    ),
                  ),
                ],
              ),
              // 시간
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "종일",
                      style: TextStyle(fontSize: 16),
                    ),
                    CustomSwitch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      trackHeight: 20,
                      trackWidth: 40,
                      toggleHeight: 20,
                      toggleWidth: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  renderTextFormField(
      {final String label = "",
      final controller,
      final focusNode,
      required hintText,
      readOnly = false,
      Function()? onTap}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
      ],
    );
  }
}
