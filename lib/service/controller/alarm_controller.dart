import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/alarm_history.dart';
import 'package:haedal/service/provider/alarm_provider.dart';

class AlarmController extends GetxController {
  late var alarmList = <AlarmHistory>[].obs;
  // Noti? currentNoti;
  final isLoading = false.obs;
  String? token;

  int unreadAlarmCount = 0.obs.value;

  // int pageNo = 0;
  // int currentIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();
    token = await storage.read(key: 'accessToken');

    if (token != null) {
      _getNotiData();
      getUnreadAlarmCount();
    }
  }

  /// 알림 리스트 가져오기
  _getNotiData() async {
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

  /// 알림 읽음 처리
  /// [alarmId] 알림 아이디
  readAlarm(String alarmId) async {
    try {
      var res = await AlarmProvider().readAlarm(alarmId);
      if (res["data"]["success"]) {
        _getNotiData();
      }
    } catch (e) {
      print(e);
    }
  }

  /// 읽지 않은 알림 갯수 가져오기
  getUnreadAlarmCount() async {
    try {
      var res = await AlarmProvider().getUnreadAlarmCount();
      unreadAlarmCount = res["data"]["unreadAlarmCount"];
      update();
    } catch (e) {
      print(e);
    }
  }

  AlarmRefresh() async {
    print('AlarmRefresh');
    if (token != null) {
      _getNotiData();
      getUnreadAlarmCount();
    }
  }
}
