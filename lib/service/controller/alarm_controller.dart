import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/alarm_history.dart';
import 'package:haedal/service/provider/alarm_provider.dart';

class AlarmController extends GetxController {
  late var alarmList = <AlarmHistory>[].obs;
  // Noti? currentNoti;
  final isLoading = false.obs;

  int unreadAlarmCount = 0.obs.value;

  // int pageNo = 0;
  // int currentIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'accessToken');

    if (token != null) {
      _getNotiData();
      getUnreadAlarmCount();
    }
  }

  /// 알림 리스트 가져오기
  _getNotiData() async {
    // notis.clear();
    isLoading.value = true;
    var notiData = await AlarmProvider().getAlarmList();

    if (notiData["data"]["success"]) {
      List<dynamic> list = notiData["data"]["alarmHistoryList"];

      alarmList
          .assignAll(list.map((item) => AlarmHistory.fromJson(item)).toList());
    }

    print("213123 , $alarmList");
    update();
    isLoading.value = false;
  }

  /// 알림 읽음 처리
  /// [alarmId] 알림 아이디
  readAlarm(String alarmId) async {
    var res = await AlarmProvider().readAlarm(alarmId);
    if (res["data"]["success"]) {
      _getNotiData();
    }
  }

  /// 읽지 않은 알림 갯수 가져오기
  getUnreadAlarmCount() async {
    var res = await AlarmProvider().getUnreadAlarmCount();
    unreadAlarmCount = res["data"]["unreadAlarmCount"];
    update();
  }
}
