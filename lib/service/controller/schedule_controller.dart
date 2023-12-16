import 'package:get/get.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/schedule_provider.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/calendar_widget.dart';

class ScheduleController extends GetxController {
  List<Meeting> meetings = <Meeting>[];

  @override
  void onInit() {
    super.onInit();
    _getDataSource();
  }

  scheduleSubmit(Map<String, dynamic> requestData) async {
    try {
      print(requestData);
      print(requestData.runtimeType);

      var res = await ScheduleProvider().create(requestData);
      var isSuccess = res["success"];
      print(res);
      print(isSuccess);
      print("isSuccess");
      if (isSuccess == true) {
        return isSuccess;
      } else {
        // res["msg"]
        return false;
      }
    } catch (e) {
      print("error: $e");
      throw Error();
    }
  }

  _getDataSource() async {
    try {
      print("RSs11");
      var res = await ScheduleProvider().getSchedule();
      var isSuccess = res["success"];
      if (isSuccess == true) {
        var responseData = res["data"];
        if (responseData != null && responseData != "") {
          List<dynamic> list = responseData;

          print("_getDataSource!!!!!! $list");
          print(" list[0][!!!: ${list[0]["title"]}");
          print(" list[0][!!!: ${list[0]["startDate"]}");
          print(" list[0][!!!: ${list[0]["endDate"]}");
          print(" list[0][!!!: ${list[0]["allDay"]}");
          print(" list[0][!!!:${list[0]["startDate"].runtimeType}");
          print(" list[0][!!!:${list[0]["allDay"].runtimeType}");
          print("DateTime(list[0])${DateTime(list[0]["startDate"])}");

          meetings.assignAll(list
              .map((item) => Meeting(
                  item["title"],
                  DateTime(item["startDate"]),
                  DateTime(item["endDate"]),
                  AppColors().mainColor,
                  item["allDay"]))
              .toList());

          print("meetings@@ : $meetings");
        }
      } else {
        return res["msg"];
      }
    } catch (e) {
      print(e);
      // throw Error();
    }
  }
}
