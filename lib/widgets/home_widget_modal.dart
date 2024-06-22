import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/widgets/home_widget_sample.dart';

class HomeWidgetModal extends StatelessWidget {
  final homeCon = Get.put(HomeController());

  HomeWidgetModal({
    Key? key,
  }) : super(
          key: key,
        );

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
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3열
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2, // 아이템의 가로 세로 비율
                    ),
                    itemCount: 9, // 아이템 수
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          homeCon.isElementVisible.value = true;
                          homeCon.elementOffset = RxOffset(100, 100);
                          homeCon.update();
                          Navigator.pop(context); // 닫기
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: home_widget_sample(index), // index에 따라 위젯 선택
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
