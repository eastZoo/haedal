import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/provider/infinite_scroll_provider.dart';

class InfiniteScrollController extends GetxController {
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
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    int offset = data.length;
    var appendData = await InfiniteScrollProvider().albumListGenerate(offset);

    print('InfiniteScrollProvider : $appendData');
    data.addAll(appendData["data"]);
    isLoading.value = false;
    hasMore.value = data.length < 30;
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    await Future.delayed(const Duration(seconds: 1));
    _getData();
  }
}
