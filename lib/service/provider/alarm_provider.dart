import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AlarmProvider {
  // 알람 리스트 얻기
  getAlarmList() async {
    return await ApiRequest(url: Endpoints.alarmUrl).asyncGet();
  }

  // 알람 읽음 처리
  readAlarm(String alarmId) async {
    return await ApiRequest(url: "${Endpoints.alarmUrl}/read/$alarmId")
        .asyncGet();
  }
}
