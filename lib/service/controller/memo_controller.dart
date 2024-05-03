import 'package:get/get.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/memo_provider.dart';

class MemoController extends GetxController {
  var memos = <Memo>[].obs;
  Memo? currentMemo;
  var isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _getMemoData();
  }

  _getMemoData() async {
    memos.clear();
    isLoading = true;
    print("_getMemoData");
    var memoData = await MemoProvider().getMemoList();

    print(" memos !!!!!!!!!!!!! :: $memoData");
    if (memoData["data"].length != 0) {
      List<dynamic> list = memoData["data"];
      memos.assignAll(list.map<Memo>((item) => Memo.fromJson(item)).toList());
    }

    print("@@@@@@@@@@@@@@@@@@@@@@ $memos");
    update();
    isLoading = false;
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

  getDetailMemoData(String id) async {
    try {
      var res = await MemoProvider().getDetailMemo(id);
      print(
        "res  : $res",
      );
      if (res["data"].length != 0) {
        currentMemo = Memo.fromJson(res["data"]["currentMemo"][0]);
      }
      update();
      isLoading = false;
      return true;
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  reload() async {
    isLoading = true;
    memos.clear();
    _getMemoData();
  }
}
