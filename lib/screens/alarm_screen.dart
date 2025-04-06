import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/alarmCategoryTranslate.dart';
import 'package:haedal/widgets/triangle_painter_widget.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmController alarmCon = Get.find<AlarmController>();

  @override
  void initState() {
    alarmCon.AlarmRefresh();
    alarmCon.readAlarm();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    alarmCon.AlarmRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmController>(
      init: AlarmController(),
      builder: (alarmCon) {
        // 시간 변환 함수
        String timeAgo(String dateTimeString) {
          final dateTime = DateTime.parse(dateTimeString);

          print(dateTime);

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
          return GestureDetector(
            onTap: () {
              print("알람 읽음!!!!!!!!");
            },
            child: Stack(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
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
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 45.w,
                        height: 45.h,
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
                      // 프로필 사진 옆 텍스트
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: AlarmCategoryTranslate(
                                  alarmCon.alarmList[index]),
                            ),
                            Text(
                              timeAgo(alarmCon.alarmList[index].createdAt
                                  .toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Conditional red slash in the top-right corner
              if (alarmCon.alarmList[index].alarmReadStatuses == false)
                Positioned(
                  top: 6,
                  right: 10,
                  child: CustomPaint(
                    size: Size(18.w, 18.h), // Width and height of the triangle
                    painter: TrianglePainter(),
                  ),
                ),
            ]),
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
