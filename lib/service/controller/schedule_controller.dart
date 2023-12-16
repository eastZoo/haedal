import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/schedule_provider.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/calendar_widget.dart';

class ScheduleController extends GetxController {
  List<Meeting> meetings = <Meeting>[];
  var colors = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getDataSource();
    getCalendarLabelColor();
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

  getCalendarLabelColor() async {
    try {
      var res = await ScheduleProvider().getLabelColor();
      var isSuccess = res["success"];
      if (isSuccess == true) {
        var responseData = res["data"];
        if (responseData != null && responseData != "") {
          List<dynamic> list = responseData;

          colors.assignAll(list
              .map<LabelColor>((item) => LabelColor.fromJson(item))
              .toList());

          print("colors   : $colors");
        }
      } else {
        return res["msg"];
      }
    } catch (e) {
      print(e);
    }
  }

// 일정 등록 후 리패칭
  refetchDataSource() async {
    await _getDataSource();
  }

  _getDataSource() async {
    try {
      var res = await ScheduleProvider().getSchedule();
      var isSuccess = res["success"];
      if (isSuccess == true) {
        var responseData = res["data"];
        if (responseData != null && responseData != "") {
          List<dynamic> list = responseData;

          meetings.assignAll(list.map((item) {
            return Meeting(
                item["title"],
                DateTime.parse(item["startDate"]).toLocal(),
                DateTime.parse(item["endDate"]).toLocal(),
                AppColors().mainColor,
                item["allDay"]);
          }).toList());

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
