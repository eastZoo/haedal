import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);
  CustomAppbar({super.key, required this.title, this.action});

  final String title;
  Widget? action;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
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
        //   icon: const Icon(Icons.search),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.person),
        // )
      ],
    );
  }
}
