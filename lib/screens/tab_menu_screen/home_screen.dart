import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/service/endpoints.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/home_widget.dart';
import 'package:haedal/widgets/home_widget_modal.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:path/path.dart' hide context;
import 'package:shared_preferences/shared_preferences.dart';

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

  bool isClick = false;

  // GlobalKey to track the position of the draggable widget
  final GlobalKey _dragKey = GlobalKey();
  final Offset _position =
      const Offset(100.0, 100.0); // Initial position of the draggable widget

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

// 배경화면 설정 모달
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

    if (image != null) {
      File? croppedImage = await _cropImage(File(image.path));
      if (croppedImage != null) {
        Map<String, dynamic> requestData = {};
        var images = [];
        images.add(await MultipartFile.fromFile(
          croppedImage.path,
          filename: basename(croppedImage.path),
        ));

        requestData["images"] = images;
        // 이미지를 nestjs에 전송
        var res = await authCon.uploadHomeImage(requestData);

        if (res) {
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeCon) {
          return GetBuilder<AuthController>(
              init: AuthController(),
              builder: (authCon) {
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
                      // 왼쪽 위 배경 변경 아이콘
                      Positioned(
                        bottom: 70,
                        left: 120,
                        child: GestureDetector(
                          onTap: () {
                            showBackgroundDialog(context);
                          },
                          child: Container(
                            width: 40, // 원의 너비
                            height: 40, // 원의 높이
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.4), // 투명도 40%
                            ),
                            alignment: Alignment.center,
                            child: Image.asset("assets/icons/camera_alt.png",
                                width: 24),
                          ),
                        ),
                      ),
                      //이모션 편집 버튼
                      Positioned(
                        bottom: 70,
                        left: 240,
                        child: GestureDetector(
                          onTap: () {
                            showBackgroundDialog(context);
                          },
                          child: Container(
                            width: 40, // 원의 너비
                            height: 40, // 원의 높이
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.4), // 투명도 40%
                            ),
                            alignment: Alignment.center,
                            child: Image.asset("assets/icons/emotion.png",
                                width: 24),
                          ),
                        ),
                      ),
                      // 왼쪽 아래 프로필 사진
                      Positioned(
                        bottom: 100,
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
                                foregroundImage: authCon
                                            .coupleInfo?.partner?.profileUrl !=
                                        null
                                    ? NetworkImage(
                                        "${authCon.coupleInfo?.partner?.profileUrl}")
                                    : null, // 조건에 따라 프로필 사진 경로 설정
                                backgroundImage: const AssetImage(
                                    "assets/icons/profile.png"),
                              ),
                            ),
                            Text(
                              authCon.coupleInfo?.me?.name ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    blurRadius: 9.0,
                                    color: Colors.black54,
                                    offset: Offset(1.0, 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 오른쪽 아래 프로필 사진
                      Positioned(
                        bottom: 100,
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
                                foregroundImage: authCon
                                            .coupleInfo?.partner?.profileUrl !=
                                        null
                                    ? NetworkImage(
                                        "${authCon.coupleInfo?.partner?.profileUrl}")
                                    : null, // 조건에 따라 프로필 사진 경로 설정

                                backgroundImage: const AssetImage(
                                    "assets/icons/profile.png"),
                              ),
                            ),
                            Text(
                              authCon.coupleInfo?.partner?.name ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8.0,
                                    color: Colors.black54,
                                    offset: Offset(1.0, 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 홈화면 위젯 관리 위젯
                      const HomeWidget(),
                      // 편집 버튼
                      Positioned(
                        bottom: 70,
                        left: 180,
                        child: GestureDetector(
                          onTap: () async {
                            homeCon.onEditButtonPressed();
                            homeCon.isEditMode.value = true;
                            await showModalBottomSheet(
                              context: context,
                              barrierColor: Colors.transparent,
                              backgroundColor: Colors.black.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return HomeWidgetModal();
                              },
                            );
                          },
                          child: Container(
                            width: 40, // 원의 너비
                            height: 40, // 원의 높이
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.4), // 투명도 40%
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
