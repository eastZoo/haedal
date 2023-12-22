import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/todo_box_item_widget.dart';

class MemoGroupWidget extends StatelessWidget {
  const MemoGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.68,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (int i = 1; i < 8; i++)
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors().mainColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: const Text(
                        "category title",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4C53A5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "0/29 완료",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                for (int i = 1; i < 8; i++)
                  Container(
                    child: const Column(
                      children: [TodoBoxItemWidget()],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }
}
