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

  refetchDataSource() async {
    print(
        "refetchDataSourcerefetchDataSourcerefetchDataSourcerefetchDataSourcerefetchDataSourcerefetchDataSourcerefetchDataSourcerefetchDataSo");
    await _getDataSource();
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

          print(" list[title][!!!: ${list[0]["title"]}");
          print(" list[startDate][!!!: ${list[0]["startDate"]}");
          print(" list[endDate][!!!: ${list[0]["endDate"]}");
          print(" list[allDay][!!!: ${list[0]["allDay"]}");

          print(
              " ===============================================================  ");

          print(" list[title][!!!: ${list[0]["title"].runtimeType}");
          print(" list[startDate][!!!: ${list[0]["startDate"].runtimeType}");
          print(" list[endDate][!!!: ${list[0]["endDate"].runtimeType}");
          print(" list[allDay][!!!: ${list[0]["allDay"].runtimeType}");

          meetings.assignAll(list.map((item) {
            return Meeting(
                item["title"],
                DateTime.parse(item["startDate"]).toLocal(),
                DateTime.parse(item["endDate"]).toLocal(),
                AppColors().mainColor,
                item["allDay"]);
          }).toList());

          print("meetings@@ : $meetings");
          update();
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
