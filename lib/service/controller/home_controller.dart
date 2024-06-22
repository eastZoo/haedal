import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
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
  RxBool isEditMode = false.obs;

  RxOffset initialOffset = RxOffset(0, 0); // 초기 위치 저장용 변수
  RxOffset elementOffset = RxOffset(100, 100);

  RxBool isElementVisible = false.obs;

  // 드래그 위치 보정용 변수
  Offset startDragOffset = Offset.zero;
  Offset elementStartOffset = Offset.zero;

  @override
  void onInit() async {
    super.onInit();
    await loadElementPosition();
  }

  // 편집 버튼을 눌렀을 때 초기 위치 저장
  void onEditButtonPressed() {
    initialOffset.setOffset(elementOffset.dx, elementOffset.dy);
    update();
  }

  // 취소 버튼을 눌렀을 때 초기 위치로 돌아가기
  void onCancelButtonPressed() {
    elementOffset.setOffset(initialOffset.dx, initialOffset.dy);
    update();
  }

  // 위젯의 위치를 저장하고 불러오기 위한 메서드
  Future<void> loadElementPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? position = prefs.getString('element_position');
    if (position != null) {
      Map<String, dynamic> posMap = jsonDecode(position);

      elementOffset.setOffset(posMap['dx'], posMap['dy']);
      isElementVisible.value = true;
      update();
    }
  }

  // 위젯의 위치를 저장하는 메서드
  Future<void> saveElementPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String position =
        jsonEncode({'dx': elementOffset.dx, 'dy': elementOffset.dy});
    await prefs.setString('element_position', position);
  }

  // 위젯의 위치를 업데이트하는 메서드
  void onPanUpdate(DragUpdateDetails details, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size screenSize = renderBox.size;

    print(
        elementStartOffset.dx + details.globalPosition.dx - startDragOffset.dx);
    print(
        elementStartOffset.dy + details.globalPosition.dy - startDragOffset.dy);

    if (elementStartOffset.dx +
                details.globalPosition.dx -
                startDragOffset.dx >=
            1 &&
        elementStartOffset.dx +
                details.globalPosition.dx -
                startDragOffset.dx <=
            265 &&
        elementStartOffset.dy +
                details.globalPosition.dy -
                startDragOffset.dy >=
            1 &&
        elementStartOffset.dy +
                details.globalPosition.dy -
                startDragOffset.dy <=
            350) {
      elementOffset.setOffset(
          elementStartOffset.dx +
              details.globalPosition.dx -
              startDragOffset.dx,
          elementStartOffset.dy +
              details.globalPosition.dy -
              startDragOffset.dy);
      update();
    }
  }
}
