import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Center(
        child: Text('알림 페이지 내용'),
      ),
    );
  }
}
