import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/provider/auth_provider.dart';
import 'package:haedal/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RxOffset {
  final RxDouble _dx;
  final RxDouble _dy;

  RxOffset(double dx, double dy)
      : _dx = RxDouble(dx),
        _dy = RxDouble(dy);

  double get dx => _dx.value;
  set dx(double value) => _dx.value = value;
  double get dy => _dy.value;
  set dy(double value) => _dy.value = value;

  void setOffset(double dx, double dy) {
    _dx.value = dx;
    _dy.value = dy;
  }

  Offset get offset => Offset(dx, dy);
}

class HomeController extends GetxController {
  final AlarmController alarmController = Get.find<AlarmController>();
  final AuthController authCon = Get.find<AuthController>();

  RxString isEditMode01 = "".obs;

  //선택한 이모지 담아두는 함수
  RxString selectedEmoji = "".obs;

  RxOffset initialOffset = RxOffset(0, 0); // 초기 위치 저장용 변수
  RxOffset elementOffset01 = RxOffset(100, 100);
  RxOffset elementOffset02 = RxOffset(200, 200);

// 처음만난날 위젯의 가시성을 제어하기 위한 변수
  RxBool first01Visible = false.obs;

  // 이모티콘 피커 visible 관련 변수
  RxBool isEmojiPickerVisible = false.obs;

  // 드래그 위치 보정용 변수
  Offset startDragOffset = Offset.zero;
  Offset elementStartOffset = Offset.zero;

  @override
  void onInit() async {
    super.onInit();
    await loadElementPosition();
    alarmController.AlarmRefresh();
  }

  // 편집 버튼을 눌렀을 때 초기 위치 저장
  void onEditButtonPressed() {
    initialOffset.setOffset(elementOffset01.dx, elementOffset01.dy);
    update();
  }

  // 취소 버튼을 눌렀을 때 초기 위치로 돌아가기
  void onCancelButtonPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String position =
        jsonEncode({'dx': initialOffset.dx, 'dy': initialOffset.dy});
    await prefs.setString('first01', position);

    elementOffset01.setOffset(initialOffset.dx, initialOffset.dy);
    await loadElementPosition();
    update();
  }

  // 위젯의 위치를 저장하고 불러오기 위한 메서드
  Future<void> loadElementPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? position = prefs.getString('first01');

    if (position != null) {
      Map<String, dynamic> posMap = jsonDecode(position);

      elementOffset01.setOffset(posMap['dx'], posMap['dy']);
      first01Visible.value = true;
      update();
    }
  }

  // 위젯의 위치를 저장하는 메서드
  Future<void> saveElementPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String position =
        jsonEncode({'dx': elementOffset01.dx, 'dy': elementOffset01.dy});
    await prefs.setString('first01', position);
  }

  // 위젯의 위치를 업데이트하는 메서드
  void onPanUpdate(DragUpdateDetails details, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size screenSize = renderBox.size;

    // 새로운 위치 계산
    double newDx =
        elementStartOffset.dx + details.globalPosition.dx - startDragOffset.dx;
    double newDy =
        elementStartOffset.dy + details.globalPosition.dy - startDragOffset.dy;

    // 경계값을 넘어가지 않도록 조정
    if (newDx < 1) newDx = 1;
    if (newDx > 285) newDx = 285;
    if (newDy < 1) newDy = 1;
    if (newDy > 450) newDy = 450;

    elementOffset01.setOffset(newDx, newDy);
    update();
  }

// 이모션 업데이트 함수
  updateEmotion() async {
    try {
      Map<String, dynamic> dataSource = {
        "emotion": selectedEmoji.value,
      };
      var res = await AuthProvider().updateEmotion(dataSource);
      if (res["success"]) {
        await authCon.getUserInfo();
        return res["success"];
      } else {
        CustomToast().alert('이모션 업데이트 실패');
        return res["success"];
      }
    } catch (e) {
      CustomToast().alert('이모션 업데이트 실패 : 서버 오류');
      print(e);
    }
  }

// 이모티콘 피커 visible 업데이트
  void updateEmojiPickerVisible(bool data) {
    isEmojiPickerVisible.value = data;
    update();
  }

// 현재 선택한 이모지 업데이트 함수 ( 저장 전 )
  void updateSelectedEmoji(String emoji) {
    selectedEmoji.value = emoji;
    update();
  }
}
