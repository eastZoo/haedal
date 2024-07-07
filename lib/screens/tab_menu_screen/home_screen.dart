import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  final AuthController authCon = Get.find<AuthController>();
  final HomeController homeCon = Get.find<HomeController>();

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

// 이모지 피커 온오프 함수
  void _toggleEmojiPicker() async {
    homeCon.updateEmojiPickerVisible(true);
    try {
      if (homeCon.isEmojiPickerVisible.value) {
        // Adjust the position based on the Positioned widget
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _dragKey.currentContext;
          if (context != null) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            // Example calculation for speech balloon position above the widget
            final balloonPosition =
                Offset(position.dx + size.width / 2, position.dy - 20);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

// 선택한 이모지 담는 함수
  void _onEmojiSelected(Emoji emoji) {
    homeCon.updateSelectedEmoji(emoji.emoji);
    // isEmojiPickerVisible = false; // 선택 후 이모티콘 피커 숨김
  }

// 배경화면 설정 모달
  void showBackgroundDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: SizedBox(
          height: 15.h,
          child: const Text(
            '메인 배경 설정',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await _pickImage();
            },
            child: const Text(
              '앨범에서 사진/동영상 선택',
              style: TextStyle(fontSize: 20),
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
              style: TextStyle(fontSize: 21),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            '취소',
            style: TextStyle(fontSize: 21),
          ),
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
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          return GetBuilder<HomeController>(
              init: HomeController(),
              builder: (homeCon) {
                return Scaffold(
                  body: Stack(
                    children: [
                      // 배경 이미지 추가
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                "${Endpoints.hostUrl}/${authCon.coupleInfo.value?.coupleData?.homeProfileUrl}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 왼쪽 아래 프로필 사진 ( 나 )
                      Positioned(
                        bottom: 100,
                        left: 20,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              opacity: _showEmotion1 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: SpeechBalloon(
                                nipLocation: NipLocation.bottom,
                                borderColor: Colors.white,
                                height: 60,
                                width: 60,
                                borderRadius: 40,
                                offset: const Offset(0, -1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${authCon.coupleInfo.value?.me?.emotion}",
                                        style: const TextStyle(fontSize: 25)),
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
                                            .coupleInfo.value?.me?.profileUrl !=
                                        null
                                    ? CachedNetworkImageProvider(
                                        "${authCon.coupleInfo.value?.me?.profileUrl}")
                                    : null,
                                backgroundImage: const AssetImage(
                                    "assets/icons/profile.png"),
                              ),
                            ),
                            Text(
                              authCon.coupleInfo.value?.me?.name ?? "",
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
                      // 오른쪽 아래 프로필 사진 ( 상대 )
                      Positioned(
                        bottom: 100,
                        right: 20,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              opacity: _showEmotion2 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: SpeechBalloon(
                                borderColor: Colors.white,
                                nipLocation: NipLocation.bottom,
                                height: 60,
                                width: 60,
                                borderRadius: 40,
                                offset: const Offset(0, -1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${authCon.coupleInfo.value?.partner?.emotion}",
                                        style: const TextStyle(fontSize: 25)),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              onTap: _toggleEmotion2,
                              child: CircleAvatar(
                                radius: 32, // 프로필 사진의 크기

                                // 오른쪽 아래 프로필 사진
                                foregroundImage: authCon.coupleInfo.value
                                            ?.partner?.profileUrl !=
                                        null
                                    ? CachedNetworkImageProvider(
                                        "${authCon.coupleInfo.value?.partner?.profileUrl}")
                                    : null,
                                backgroundImage: const AssetImage(
                                    "assets/icons/profile.png"),
                              ),
                            ),
                            Text(
                              authCon.coupleInfo.value?.partner?.name ?? "",
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
                      // 이모지 선택 시 배경화면 블러처리
                      Obx(
                        () => homeCon.isEmojiPickerVisible.value
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              )
                            : Container(),
                      ),
                      Obx(() => homeCon.isEmojiPickerVisible.value
                          ? Positioned(
                              top: 100,
                              right: 175,
                              child: Column(
                                children: [
                                  SpeechBalloon(
                                    borderColor: Colors.white,
                                    nipLocation: NipLocation.bottom,
                                    height: 60,
                                    width: 60,
                                    borderRadius: 40,
                                    offset: const Offset(0, -1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(homeCon.selectedEmoji.value,
                                            style:
                                                const TextStyle(fontSize: 25)),
                                      ],
                                    ),
                                  ),
                                  const Gap(15),
                                  GestureDetector(
                                    onTap: _toggleEmotion2,
                                    child: CircleAvatar(
                                      radius: 32, // 프로필 사진의 크기
                                      // 오른쪽 아래 프로필 사진
                                      foregroundImage: authCon.coupleInfo.value
                                                  ?.me?.profileUrl !=
                                              null
                                          ? CachedNetworkImageProvider(
                                              "${authCon.coupleInfo.value?.me?.profileUrl}")
                                          : null,
                                      backgroundImage: const AssetImage(
                                          "assets/icons/profile.png"),
                                    ),
                                  ),
                                  Text(
                                    authCon.coupleInfo.value?.partner?.name ??
                                        "",
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
                            )
                          : Container()),
                      // 이모지 선택 시 이모지 피커 온오프
                      Obx(() => homeCon.isEmojiPickerVisible.value
                          ? Positioned(
                              key: _dragKey,
                              bottom: 180,
                              left: 30,
                              child: SizedBox(
                                // Adjust the height as per your need
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: SpeechBalloon(
                                    borderRadius: 15,
                                    height: 300,
                                    width: 350,
                                    child: EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        _onEmojiSelected(emoji);
                                      },
                                      config: const Config(
                                        height: 100,
                                        checkPlatformCompatibility: false,
                                        emojiViewConfig: EmojiViewConfig(
                                          // Issue: https://github.com/flutter/flutter/issues/28894
                                          columns: 8,
                                          emojiSizeMax: 30,
                                        ),
                                        swapCategoryAndBottomBar: true,
                                        skinToneConfig: SkinToneConfig(),
                                        categoryViewConfig:
                                            CategoryViewConfig(),
                                        bottomActionBarConfig:
                                            BottomActionBarConfig(
                                                enabled: false),
                                        searchViewConfig: SearchViewConfig(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()),

                      // # 1 배경 변경 아이콘
                      homeCon.isEditMode01.value == "emotion" ||
                              homeCon.isEditMode01.value == "home"
                          ? Container()
                          : Positioned(
                              bottom: 110,
                              left: 125,
                              child: GestureDetector(
                                onTap: () {
                                  showBackgroundDialog(context);
                                },
                                child: Container(
                                  width: 40, // 원의 너비
                                  height: 40, // 원의 높이
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Colors.grey.withOpacity(0.4), // 투명도 40%
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      "assets/icons/camera_alt.png",
                                      width: 24),
                                ),
                              ),
                            ),
                      // #2 홈화면 편집 버튼
                      homeCon.isEditMode01.value == "home"
                          ?
                          // 위젯 편집 모드일때 넓이 조절
                          Positioned(
                              bottom: 110,
                              left: 145,
                              child: GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    barrierColor: Colors.transparent,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return const HomeWidgetModal();
                                    },
                                  );
                                },
                                child: Container(
                                  width: 120, // 원의 너비
                                  height: 40, // 원의 높이
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        Colors.grey.withOpacity(0.4), // 투명도 40%
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.edit,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : homeCon.isEditMode01.value == "emotion"
                              ? Container()
                              : Positioned(
                                  bottom: 110,
                                  left: 185,
                                  child: GestureDetector(
                                    onTap: () async {
                                      // 편집 버튼을 눌렀을 때 초기 위치 저장
                                      homeCon.onEditButtonPressed();
                                      homeCon.isEditMode01.value = "home";
                                      await showModalBottomSheet(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.5),
                                        builder: (BuildContext context) {
                                          return const HomeWidgetModal();
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 40, // 원의 너비
                                      height: 40, // 원의 높이
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey
                                            .withOpacity(0.4), // 투명도 40%
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.edit,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                      // # 3 이모션 편집 버튼
                      homeCon.isEditMode01.value == "emotion"
                          ? Positioned(
                              bottom: 110,
                              left: 145,
                              child: GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  width: 120, // 원의 너비
                                  height: 40, // 원의 높이
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        Colors.grey.withOpacity(0.4), // 투명도 40%
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset("assets/icons/emotion.png",
                                      width: 24),
                                ),
                              ),
                            )
                          : homeCon.isEditMode01.value == "home"
                              ? Container()
                              : Positioned(
                                  bottom: 110,
                                  left: 245,
                                  child: GestureDetector(
                                    onTap: () {
                                      homeCon.isEditMode01.value = "emotion";
                                      _toggleEmojiPicker();
                                    },
                                    child: Container(
                                      width: 40, // 원의 너비
                                      height: 40, // 원의 높이
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey
                                            .withOpacity(0.4), // 투명도 40%
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          "assets/icons/emotion.png",
                                          width: 24),
                                    ),
                                  ),
                                )
                    ],
                  ),
                );
              });
        });
  }
}
