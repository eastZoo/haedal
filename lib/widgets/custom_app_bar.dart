import 'package:flutter/material.dart';
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
      this.currentToggleIdx});

  final Function(int)? updateToggleIdx;

  final int? currentToggleIdx;
  final String title;
  final int? selectedIndex;

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
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(
              20, 0, 0, 0), // 아이콘 주위에 패딩을 추가하여 여백을 만듭니다.
          child: Image.asset(
            'assets/icons/logo.png',
          ), // 로고 아이콘 경로
        ),
        title: _appBarTitle(selectedIndex!),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Image.asset(
                "assets/icons/notice.png",
                width: 25,
              ),
            ),
            Positioned(
              right: 15,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: AppColors().noticeRed,
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
