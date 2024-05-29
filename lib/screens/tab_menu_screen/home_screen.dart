import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 날짜를 가져옵니다.
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd.EEE')
        .format(now)
        .toUpperCase(); // 원하는 형식으로 날짜 포맷팅

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/background.png'), // 배경 이미지 경로
                fit: BoxFit.cover,
              ),
            ),
          ),
          //오른쪽 위 날짜 디데이
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                      color: AppColors().white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Text(
                  "428일",
                  style: TextStyle(
                      color: AppColors().white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                Row(
                  children: [
                    Text(
                      "김영광",
                      style: TextStyle(
                          color: AppColors().white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Icon(Icons.favorite, color: AppColors().white, size: 18),
                    Text(
                      "이성경",
                      style: TextStyle(
                          color: AppColors().white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
          // 왼쪽 위 배경 변경 아이콘
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 40, // 원의 너비
              height: 40, // 원의 높이
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.8), // 투명도 50%
              ),
              alignment: Alignment.center,
              child: Image.asset("assets/icons/camera_alt.png", width: 24),
            ),
          ),
          // 왼쪽 아래 프로필 사진
          Positioned(
            bottom: 120,
            left: 20,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 32, // 프로필 사진의 크기
                  backgroundImage: AssetImage(
                      'assets/icons/profile1.png'), // 왼쪽 아래 프로필 사진 경로
                ),
                Text(
                  "김영광",
                  style: TextStyle(
                      color: AppColors().white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                )
              ],
            ),
          ),
          // 오른쪽 아래 프로필 사진
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 32, // 프로필 사진의 크기
                  backgroundImage: AssetImage(
                      'assets/icons/profile2.png'), // 왼쪽 아래 프로필 사진 경로
                ),
                Text(
                  "이성경",
                  style: TextStyle(
                      color: AppColors().white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
