import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:speech_balloon/speech_balloon.dart';

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
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          // 현재 날짜
          DateTime currentDate = DateTime.now();

          // 두 날짜 사이의 차이 계산
          Duration difference = currentDate.difference(
              authCon.coupleInfo?.coupleData?.firstDay ?? DateTime.now());

          // D-Day 계산
          int dDay = difference.inDays;

          return Scaffold(
            body: Stack(
              children: [
                // 배경 이미지 추가
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/icons/background.png'), // 배경 이미지 경로
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
                        authCon.coupleInfo?.coupleData?.firstDay.toString() ??
                            "", // foattedDate 대신 임시 문자열 사용
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        "${dDay.toString()}일",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                      Row(
                        children: [
                          Text(
                            authCon.coupleInfo?.me?.name ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          const Icon(Icons.favorite,
                              color: Colors.white, size: 18),
                          Text(
                            authCon.coupleInfo?.partner?.name ?? "",
                            style: const TextStyle(
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
                      child:
                          Image.asset("assets/icons/camera_alt.png", width: 24),
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
                        child: const SpeechBalloon(
                          nipLocation: NipLocation.bottom,
                          borderColor: Colors.white,
                          height: 60,
                          width: 60,
                          borderRadius: 40,
                          offset: Offset(0, -1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('😜', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      const Gap(15),
                      GestureDetector(
                        onTap: _toggleEmotion1,
                        child: CircleAvatar(
                          radius: 32, // 프로필 사진의 크기
                          backgroundImage: NetworkImage(authCon
                                  .coupleInfo?.me?.profileUrl ??
                              'assets/icons/profile1.png'), // 왼쪽 아래 프로필 사진 경로
                        ),
                      ),
                      Text(
                        authCon.coupleInfo?.me?.name ?? "",
                        style: const TextStyle(
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
                        child: const SpeechBalloon(
                          borderColor: Colors.white,
                          nipLocation: NipLocation.bottom,
                          height: 60,
                          width: 60,
                          borderRadius: 40,
                          offset: Offset(0, -1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('😜', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      const Gap(15),
                      GestureDetector(
                        onTap: _toggleEmotion2,
                        child: CircleAvatar(
                          radius: 32, // 프로필 사진의 크기
                          backgroundImage: NetworkImage(authCon
                                  .coupleInfo?.partner?.profileUrl ??
                              'assets/icons/profile2.png'), // 오른쪽 아래 프로필 사진 경로
                        ),
                      ),
                      Text(
                        authCon.coupleInfo?.partner?.name ?? "",
                        style: const TextStyle(
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
        });
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
