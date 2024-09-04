import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:haedal/models/alarm_history.dart';
import 'package:haedal/service/provider/alarm_provider.dart';

class AlarmController extends GetxController {
  late var alarmList = <AlarmHistory>[].obs;
  // Noti? currentNoti;
  final isLoading = false.obs;
  String? token;

  RxInt unreadAlarmCount = 0.obs;

  // int pageNo = 0;
  // int currentIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();
    token = await storage.read(key: 'accessToken');

    if (token != null) {
      getNotiData();
      getUnreadAlarmCount();
    }
  }

  /// 알림 리스트 가져오기
  getNotiData() async {
    // notis.clear();
    isLoading.value = true;
    try {
      var notiData = await AlarmProvider().getAlarmList();

      if (notiData["data"]["success"]) {
        List<dynamic> list = notiData["data"]["alarmHistoryList"];

        alarmList.assignAll(
            list.map((item) => AlarmHistory.fromJson(item)).toList());
      }
      update();
      isLoading.value = false;
    } catch (e) {
      print(e);

      isLoading.value = false;
    }
  }

  /// 알림 모두 읽음 처리
  readAlarm() async {
    try {
      print("알람 읽음 처리");
      var res = await AlarmProvider().readAlarm();
      if (res["data"]["success"]) {
        getNotiData();
      }
    } catch (e) {
      print(e);
    }
  }

  /// 읽지 않은 알림 갯수 가져오기
  getUnreadAlarmCount() async {
    try {
      var res = await AlarmProvider().getUnreadAlarmCount();
      print("AlarmRefresh ${res["data"]["unreadAlarmCount"]}");
      unreadAlarmCount.value = res["data"]["unreadAlarmCount"];
    } catch (e) {
      print(e);
    }
  }

  AlarmRefresh() async {
    print('AlarmRefresh');
    if (token != null) {
      getNotiData();
      getUnreadAlarmCount();
    }
  }
}
