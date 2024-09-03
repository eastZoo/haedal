import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AlarmProvider {
  // 알람 리스트 얻기
  getAlarmList() async {
    return await ApiRequest(url: Endpoints.alarmUrl).asyncGet();
  }

  // 알람 읽음 처리
  readAlarm() async {
    return await ApiRequest(url: "${Endpoints.alarmUrl}/read").asyncGet();
  }

// 읽지 않은 알람 갯수 가져오기
  getUnreadAlarmCount() async {
    return await ApiRequest(url: "${Endpoints.alarmUrl}/unread-all").asyncGet();
  }
}
