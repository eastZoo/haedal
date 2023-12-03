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

    int offset = data.length;
    print("offset");
    print(offset);
    var albumData = await InfiniteScrollProvider().albumListGenerate(offset);

    print('InfiniteScrollProvider : $albumData');
    data.addAll(albumData["data"]["appendData"]);
    isLoading.value = false;
    hasMore.value = data.length < albumData["data"]["total"];
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    _getData();
  }
}
