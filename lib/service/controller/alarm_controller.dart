import 'package:get/get.dart';
import 'package:haedal/models/alarm_history.dart';
import 'package:haedal/service/provider/alarm_provider.dart';

class AlarmController extends GetxController {
  late var alarmList = <AlarmHistory>[].obs;
  // Noti? currentNoti;
  final isLoading = false.obs;

  // int pageNo = 0;
  // int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _getNotiData();
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
}
