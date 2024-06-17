import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmController>(
      init: AlarmController(),
      builder: (alarmCon) {
        print("qeweqwe ${alarmCon.alarmList}");
        // 할일 타일
        Widget buildTaskTile(int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors().white,
            ),
            child: Text(
                '내용 :  ${alarmCon.alarmList[index].content} / type :  ${alarmCon.alarmList[index].type}'),
          );
        }

        return Scaffold(
          backgroundColor: AppColors().toDoGrey,
          appBar: AppBar(
            title: Text(
              '알림',
              style: TextStyle(
                color: AppColors().darkGreyText,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: AppColors().white,
            iconTheme: IconThemeData(color: AppColors().darkGreyText),
            centerTitle: true,
            surfaceTintColor: AppColors().white, // 화면에서 스크롤로 변경되더 상단바 색상 고정
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // 전체
                        Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors().mainColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '전체',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 읽지 않음
                        Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors().darkGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '읽지 않음',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: alarmCon.alarmList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildTaskTile(index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
