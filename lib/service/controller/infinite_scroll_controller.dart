import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfiniteScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <int>[].obs;
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
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    int offset = data.length;
    var appendData = List<int>.generate(10, (i) => i + 1 + offset);
    data.addAll(appendData);
    isLoading.value = false;
    hasMore.value = data.length < 30;
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    await Future.delayed(const Duration(seconds: 2));
    _getData();
  }
}
