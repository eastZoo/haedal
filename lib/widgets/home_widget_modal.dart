import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/home_widget_dday_sample.dart';
import 'package:haedal/widgets/home_widget_firstday_sample.dart';

class HomeWidgetModal extends StatefulWidget {
  const HomeWidgetModal({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<HomeWidgetModal> createState() => _HomeWidgetModalState();
}

class _HomeWidgetModalState extends State<HomeWidgetModal> {
  final homeCon = Get.put(HomeController());
  ScrollController scrollController = ScrollController();

  String homeWidgetCategory = "firstDay";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeCon) {
          return SizedBox(
            height: 370.h,
            child: Column(
              children: [
                const Gap(10),
                Center(
                  child: Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: Colors.white,
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3열
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1, // 아이템의 가로 세로 비율
                    ),
                    itemCount: 1, // 아이템 수
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print("index: $index");
                          switch (index) {
                            case 0:
                              homeCon.first01Visible.value = true;
                              homeCon.elementOffset01 = RxOffset(100, 100);
                              homeCon.update();
                              break;
                            default:
                              break;
                          }
                          Navigator.pop(context); // 닫기
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: homeWidgetCategory == "firstDay"
                              ? home_widget_firstday_sample(
                                  index) // 처음 만난날 위젯 샘플
                              : home_widget_dday_sample(index), // d-day 위젯 샘플
                        ),
                      );
                    },
                  ),
                ),
                // Footer Navigation Bar
                Container(
                  height: 80.h,
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        icon: Image.asset('assets/icons/firstDay.png',
                            color: Colors.white, width: 30.w, height: 25.h),
                        onPressed: () {
                          scrollController.jumpTo(0);
                          // D-day 버튼 눌렀을 때 동작
                          setState(() {
                            homeWidgetCategory = "firstDay";
                          });
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        icon: Image.asset('assets/icons/Dday.png',
                            color: Colors.white, width: 30.w, height: 25.h),
                        onPressed: () {
                          scrollController.jumpTo(0);
                          // D-day 버튼 눌렀을 때 동작
                          setState(() {
                            homeWidgetCategory = "D-day";
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
