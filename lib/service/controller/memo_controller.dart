import 'package:get/get.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/memo_provider.dart';

class MemoController extends GetxController {
  var memos = <Memo>[].obs;
  Memo? currentMemo;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getMemoData();
  }

  /// 메모 카테고리 및 하위 리스트 가져오기
  _getMemoData() async {
    memos.clear();
    isLoading.value = true;
    var memoData = await MemoProvider().getMemoList();

    if (memoData["data"].length != 0) {
      List<dynamic> list = memoData["data"];
      memos.assignAll(list.map<Memo>((item) => Memo.fromJson(item)).toList());
    }
    update();
    isLoading.value = false;
  }

  /// 메모 카테고리 생성
  createMemoCategory(requestData) async {
    try {
      isLoading.value = true;
      var res = await MemoProvider().createMemoCategory(requestData);
      var isSuccess = res["success"];
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
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 메모 체크박스 업데이트
  updateMemoItem(data) async {
    try {
      isLoading.value = true;
      var res = await MemoProvider().updateMemoItem(data);
      var isSuccess = res["data"]["success"];

      print("  String errorMsg = " "; $isSuccess");
      if (isSuccess == true) {
        await _getMemoData();
        return isSuccess;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw Error();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 메모 생성
  createMemo(data) async {
    try {
      isLoading.value = true;
      var res = await MemoProvider().createMemo(data);
      var isSuccess = res["success"];
      if (isSuccess == true) {
        await _getMemoData();
        return isSuccess;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw Error();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  getDetailMemoData(String id) async {
    try {
      isLoading.value = true;
      var res = await MemoProvider().getDetailMemo(id);
      if (res["data"].length != 0) {
        currentMemo = Memo.fromJson(res["data"]["currentMemo"][0]);
      }

      return true;
    } catch (e) {
      print(e);
      throw Error();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 메모 리스트 리패칭
  reload() async {
    try {
      isLoading.value = true;
      await _getMemoData();
      return true;
    } catch (e) {
      print(e);

      return false;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
