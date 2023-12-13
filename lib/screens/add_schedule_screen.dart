import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
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

  TextEditingController titleTextController = TextEditingController();
  // _addCurrentDaySchedule() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(25.0),
  //       ),
  //     ),
  //     builder: (context) => DraggableScrollableSheet(
  //         initialChildSize: 0.9,
  //         maxChildSize: 0.9,
  //         minChildSize: 0.8,
  //         expand: false,
  //         snap: true,
  //         builder: (context, scrollController) {
  //           return SingleChildScrollView(
  //             controller: scrollController,
  //             child: AddScheduleScreen(selectedDay: selectedDay),
  //           );
  //         }),
  //   );
  // }

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
              // 메인 타이틀 ( 요일 , 추가 아이콘 )
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
        Row(
          children: [
            label.isNotEmpty
                ? Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
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
        )
      ],
    );
  }
}
