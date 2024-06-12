import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
