import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        String timeAgo(String dateTimeString) {
          final dateTime = DateTime.parse(dateTimeString);
          final now = DateTime.now();
          final difference = now.difference(dateTime);

          if (difference.inSeconds < 60) {
            return '${difference.inSeconds}초 전';
          } else if (difference.inMinutes < 60) {
            return '${difference.inMinutes}분 전';
          } else if (difference.inHours < 24) {
            return '${difference.inHours}시간 전';
          } else if (difference.inDays < 30) {
            return '${difference.inDays}일 전';
          } else if (difference.inDays < 365) {
            return '${difference.inDays ~/ 30}개월 전';
          } else {
            return '${difference.inDays ~/ 365}년 전';
          }
        }

        print("qeweqwe ${alarmCon.alarmList}");
        // 할일 타일
        Widget buildTaskTile(int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: AppColors().white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상
                  spreadRadius: 1, // 그림자 확산 반경
                  blurRadius: 1, // 그림자 흐림 정도
                  offset: const Offset(0, 1.5), // 그림자 위치 (x, y)
                ),
              ],
            ),
            child: Container(
              height: 60.h,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        foregroundImage: alarmCon
                                    .alarmList[index].user?.profileUrl !=
                                null
                            ? NetworkImage(
                                "${alarmCon.alarmList[index].user?.profileUrl}")
                            : null, // 조건에 따라 프로필 사진 경로 설정
                        backgroundImage:
                            const AssetImage("assets/icons/profile.png"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                          '${alarmCon.alarmList[index].user?.name} 님이 ${alarmCon.alarmList[index].type}를 ${alarmCon.alarmList[index].crud}'),
                      Text(timeAgo(
                          alarmCon.alarmList[index].createdAt.toString())),
                    ],
                  ),
                ],
              ),
            ),
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
                padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // 전체
                        Container(
                          width: 62.w,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors().mainColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              '전체',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 읽지 않음
                        Container(
                          width: 85.w,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors().darkGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '읽지 않음',
                              style: TextStyle(
                                fontSize: 12.sp,
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
