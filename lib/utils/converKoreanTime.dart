import 'package:intl/intl.dart';

String convertToKoreanTime(String dateTimeString) {
  // 문자열을 DateTime 객체로 파싱
  DateTime utcDateTime = DateTime.parse(dateTimeString);

  // 9시간을 더해 한국 시간으로 변환
  DateTime koreanDateTime = utcDateTime.add(const Duration(hours: 9));

  print(dateTimeString);

  // 원하는 포맷으로 변환
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  return dateFormat.format(utcDateTime);
}
