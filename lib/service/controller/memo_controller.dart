import 'package:get/get.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/memo_provider.dart';

class MemoController extends GetxController {
  var memos = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getMemoData();
  }

  _getMemoData() async {
    isLoading.value = true;
    print("_getMemoData");
    var memoData = await MemoProvider().getMemoList();

    print(" ::::::!!!! $memoData");
    if (memoData["data"].length != 0) {
      memos.addAll(memoData["data"]);
    }

    print("@@@@@@@@@@@@@@@@@@@@@@ $memos");
    isLoading.value = false;
  }

  createMemoCategory(requestData) async {
    try {
      var res = await MemoProvider().create(requestData);
      var isSuccess = res["success"];
      print(res);
      print(isSuccess);
      print("isSuccess");
      if (isSuccess == true) {
        await _getMemoData();
        return isSuccess;
      } else {
        print(res["msg"]);
        return false;
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  reload() async {
    isLoading.value = true;
    memos.clear();
    _getMemoData();
  }
}
