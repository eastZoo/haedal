import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  CustomAppbar(
      {super.key,
      required this.title,
      this.action,
      this.selectedIndex,
      this.updateToggleIdx,
      this.currentToggleIdx,
      this.onNotificationIconTap});

  final Function(int)? updateToggleIdx;
  final int? currentToggleIdx;
  final String title;
  final int? selectedIndex;
  final VoidCallback? onNotificationIconTap;

  Widget _appBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      // 홈 메인 화면
      case 0:
        return Container();
      // 메모 투두리스트 화면
      case 1:
        return Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors().darkGreyText,
          ),
        );
      case 2:
        return ToggleSwitch(
          minWidth: 60.0,
          cornerRadius: 20.0,
          initialLabelIndex: currentToggleIdx,
          totalSwitches: 2,
          labels: const ['카드', '지도'],
          activeBgColor: [AppColors().mainColor],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[100],
          radiusStyle: true,
          onToggle: (index) {
            updateToggleIdx!(index!);
          },
        );
      case 3:
        return Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors().darkGreyText,
          ),
        );
      case 4:
        return Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors().darkGreyText,
          ),
        );
      case 5:
        return Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors().darkGreyText,
          ),
        );
      default:
        return Text(
          '기본 타이틀',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors().darkGreyText,
          ),
        );
    }
  }

  Widget? action;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeCon) {
          return GetBuilder<AlarmController>(
              init: AlarmController(),
              builder: (alarmCon) {
                return PreferredSize(
                  preferredSize: const Size.fromHeight(150.0),
                  child: AppBar(
                    leadingWidth: 130,
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Obx(() => homeCon.isEditMode01.value == "home" ||
                              homeCon.isEditMode01.value == "emotion"
                          ? GestureDetector(
                              onTap: () {
                                // 현재 홈 화면 편집상태가 emotion일때 취소누르면 이모션 피커 닫기
                                if (homeCon.isEditMode01.value == "emotion") {
                                  homeCon.updateEmojiPickerVisible(false);
                                }

                                // 현재 홈화면 편집 상태가 home 일때 취소 누르면 상태 취소 함수 실행
                                if (homeCon.isEditMode01.value == "home") {
                                  homeCon.onCancelButtonPressed();
                                }
                                homeCon.isEditMode01.value = "";
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                      color: AppColors().mainColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/icons/logo.png',
                            )),
                    ),
                    title: _appBarTitle(selectedIndex!),
                    backgroundColor: AppColors().white,
                    surfaceTintColor:
                        AppColors().white, // 화면에서 스크롤로 변경되더 상단바 색상 고정
                    centerTitle: true,
                    actions: [
                      Obx(() => homeCon.isEditMode01.value == "home" ||
                              homeCon.isEditMode01.value == "emotion"
                          ? GestureDetector(
                              onTap: () {
                                if (homeCon.isEditMode01.value == "home") {
                                  homeCon.update();
                                }
                                if (homeCon.isEditMode01.value == "emotion") {
                                  // 이모션 상태 업데이트 함수
                                  var res = homeCon.updateEmotion();

                                  if (res == false) {
                                    return;
                                  }
                                  // 이모션 피커 닫기
                                  homeCon.updateEmojiPickerVisible(false);
                                }
                                homeCon.isEditMode01.value = "";
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Text(
                                  '저장',
                                  style: TextStyle(
                                      color: AppColors().mainColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: onNotificationIconTap,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Image.asset(
                                      "assets/icons/notice.png",
                                      width: 25,
                                    ),
                                  ),
                                  Positioned(
                                    right: 15,
                                    child: Obx(() => CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              alarmCon.unreadAlarmCount.value ==
                                                      0
                                                  ? AppColors().lightGrey
                                                  : AppColors().noticeRed,
                                          child: Text(
                                            alarmCon.unreadAlarmCount.value
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ))
                    ],
                  ),
                );
              });
        });
  }
}
