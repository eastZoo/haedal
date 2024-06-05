import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/endpoints.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:path/path.dart' hide context;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authCon = Get.put(AuthController());

  bool _showEmotion1 = false;
  bool _showEmotion2 = false;
  File? _backgroundImage;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    print(image);
    if (image != null) {
      File? croppedImage = await _cropImage(File(image.path));
      if (croppedImage != null) {
        Map<String, dynamic> requestData = {};
        var images = [];
        print("croppedImage.path: ${croppedImage.path}");
        images.add(await MultipartFile.fromFile(
          croppedImage.path,
          filename: basename(croppedImage.path),
        ));

        requestData["images"] = images;
        // 이미지를 nestjs에 전송
        var res = await authCon.uploadHomeImage(requestData);

        if (res) {
          print("이미지 업로드 성공");
          await authCon.getUserInfo();
        }
      }
    } else {
      CustomToast().alert("이미지를 선택해주세요.");
    }
  }

  // 이미지 자르기
  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '배경 이미지 설정',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: '배경 이미지 설정',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  void showBackgroundDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('메인 배경 설정'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await _pickImage();
            },
            child: const Text(
              '앨범에서 사진/동영상 선택',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _backgroundImage = null;
              });
            },
            child: const Text(
              '기본 이미지',
            ),
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

          // D-Day 계산 사귄날 ( +1 )
          int dDay = difference.inDays + 1;

          return Scaffold(
            body: Stack(
              children: [
                // 배경 이미지 추가
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "${Endpoints.hostUrl}/${authCon.coupleInfo?.coupleData?.homeProfileUrl}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 오른쪽 위 날짜 디데이
                Positioned(
                  top: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                            authCon.coupleInfo?.coupleData?.firstDay ??
                                DateTime.now()), // 첫 만남 날짜
                        // formattedDate 대신 임시 문자열 사용
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
                      showBackgroundDialog(context);
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
                          backgroundImage: NetworkImage(
                              "${authCon.coupleInfo?.me?.profileUrl}"), // 왼쪽 아래 프로필 사진 경로
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
                          backgroundImage: NetworkImage(
                              "${authCon.coupleInfo?.partner?.profileUrl}"), // 오른쪽 아래 프로필 사진 경로
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
}
