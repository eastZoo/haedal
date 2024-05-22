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
  Widget? action;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: selectedIndex == 2
          ? ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              initialLabelIndex: currentToggleIdx,
              totalSwitches: 2,
              labels: const ['카드', '지도'],
              activeBgColor: [AppColors().mainColor],
              inactiveBgColor: Colors.grey[100],
              radiusStyle: true,
              onToggle: (index) {
                updateToggleIdx!(index!);
              })
          : Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors().appBarPrimary),
            ),
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: const [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.person),
        // )
      ],
    );
  }
}
