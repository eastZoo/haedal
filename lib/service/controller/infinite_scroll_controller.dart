import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/provider/infinite_scroll_provider.dart';

class InfiniteScrollController extends GetxController {
  // GetX 컨트롤러 가져오기
  final AlarmController alarmController = Get.find<AlarmController>();
  var scrollController = ScrollController().obs;
  var data = <dynamic>[].obs;
  var isLoading = false.obs;
  var hasMore = false.obs;

  @override
  void onInit() {
    _getData();
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
    try {
      isLoading.value = true;

      int offset = data.length;

      var result = await InfiniteScrollProvider().albumListGenerate(offset);

      data.addAll(result["data"]["appendData"]);
      isLoading.value = false;
      hasMore.value = data.length < result["data"]["total"];

      // 알림목록 리패칭
      await alarmController.AlarmRefresh();
    } catch (e) {
      print(e);
    }
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    _getData();
  }
}
