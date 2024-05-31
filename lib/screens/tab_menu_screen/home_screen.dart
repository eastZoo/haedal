import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/styles/colors.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showEmotion1 = false;
  bool _showEmotion2 = false;

  void _toggleEmotion1() {
    setState(() {
      _showEmotion1 = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showEmotion1 = false;
      });
    });
  }

  void _toggleEmotion2() {
    setState(() {
      _showEmotion2 = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showEmotion2 = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          const Positioned(
            top: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '2024-05-31', // formattedDate 대신 임시 문자열 사용
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Text(
                  "428일",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                Row(
                  children: [
                    Text(
                      "김영광",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Icon(Icons.favorite, color: Colors.white, size: 18),
                    Text(
                      "이성경",
                      style: TextStyle(
                          color: Colors.white,
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
            child: GestureDetector(
              onTap: () {
                _showBackgroundDialog(context);
              },
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
          ),
          // 왼쪽 아래 프로필 사진
          Positioned(
            bottom: 120,
            left: 20,
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _showEmotion1 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '😊', // 감정 표시 텍스트
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleEmotion1,
                  child: const CircleAvatar(
                    radius: 32, // 프로필 사진의 크기
                    backgroundImage: AssetImage(
                        'assets/icons/profile1.png'), // 왼쪽 아래 프로필 사진 경로
                  ),
                ),
                const Text(
                  "김영광",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ),
          // 오른쪽 아래 프로필 사진
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _showEmotion2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '😍', // 감정 표시 텍스트
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleEmotion2,
                  child: const CircleAvatar(
                    radius: 32, // 프로필 사진의 크기
                    backgroundImage: AssetImage(
                        'assets/icons/profile2.png'), // 오른쪽 아래 프로필 사진 경로
                  ),
                ),
                const Text(
                  "이성경",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBackgroundDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('메인 배경 설정'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('앨범에서 사진/동영상 선택'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('기본 이미지'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
      ),
    );
  }
}
