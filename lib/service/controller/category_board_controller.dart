import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/provider/category_board_provider.dart';

class CategoryBoardController extends GetxController {
  final AlarmController alarmController = Get.find<AlarmController>();
  var scrollController = ScrollController().obs;
  var data = <dynamic>[].obs;
  var isLoading = false.obs;
  var hasMore = false.obs;

  var category = "".obs;

  @override
  void onInit() {
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        _getData();
      }
    });
    super.onInit();
  }

  _getData() async {
    print("iscategory :  $category");
    isLoading.value = true;

    int offset = data.length;

    var albumData =
        await CategoryBoardProvider().categoryListGenerate(offset, category);
    data.addAll(albumData["data"]["appendData"]);
    isLoading.value = false;
    hasMore.value = data.length < albumData["data"]["total"];

    await alarmController.AlarmRefresh();
  }

  setCategory(currentCategory) {
    // 현재 카테고리 이름과 같지 않다면 리스트 초기화
    if (category != currentCategory) {
      data.clear();
      update();
    }
    category = RxString(currentCategory);
    update();
    _getData();
    return true;
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    _getData();
  }
}
