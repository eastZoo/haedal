import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/models/work_table.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/schedule_provider.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/calendar_widget.dart';

class ScheduleController extends GetxController {
  List<Meeting> meetings = <Meeting>[];

  var colors = <dynamic>[].obs;
  WorkTable? currentWorkTableUrl;

  @override
  void onInit() {
    super.onInit();
    _getDataSource();
    getCalendarLabelColor();
  }

  scheduleSubmit(Map<String, dynamic> requestData) async {
    try {
      var res = await ScheduleProvider().create(requestData);
      var isSuccess = res["success"];

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

// 현재 선택된 월의 근무표 받아오기
  getCurrentWorkTableUrl(month) async {
    try {
      print("MONTH : : : $month");
      var res = await ScheduleProvider().getCurrentWorkTableUrl(month);
      var isSuccess = res["success"];

      if (isSuccess == true) {
        var responseData = res["data"]["currentWorkTableUrl"];
        if (responseData != null && responseData != "null") {
          currentWorkTableUrl =
              WorkTable.fromJson(res["data"]["currentWorkTableUrl"][0]);

          print("&************************ $currentWorkTableUrl");
          update();
        } else {
          print("no data!!!");
          currentWorkTableUrl = null;
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

// 근무표 사진 삭제 하기
  deleteWorkTable(id) async {
    try {
      var res = await ScheduleProvider().deleteWorkTable(id);
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
      print(e);
      throw Error();
    }
  }

// 근무표 사진 전송
  workTableSubmit(requestData) async {
    try {
      var res = await ScheduleProvider().workTableSubmit(requestData);
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
      print(e);
      throw Error();
    }
  }

// 일정 등록 후 리패칭
  refetchDataSource() async {
    await _getDataSource();
  }

// 모든 일정 얻기
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
                Color(int.parse(item["color"])),
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
