import 'package:get/get.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/service/provider/schedule_provider.dart';

class ScheduleController extends GetxController {
  scheduleSubmit(requestData) async {
    try {
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
      print(e);
      throw Error();
    }
  }
}
