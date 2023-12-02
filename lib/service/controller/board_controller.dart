import 'package:get/get.dart';
import 'package:haedal/service/provider/board_provider.dart';

class BoardController extends GetxController {
  postSubmit(requestData) async {
    try {
      var res = await BoardProvider().create(requestData);
      var isSuccess = res["success"];
      print(isSuccess);
      print("isSuccess");
      if (isSuccess == true) {
        return isSuccess;
      } else {
        return res["msg"];
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
