import 'package:get/get.dart';
import 'package:haedal/service/provider/board_provider.dart';

class BoardController extends GetxController {
  postSubmit(requestData) async {
    try {
      var res = await BoardProvider().create(requestData);

      if (res["success"]) {
        return res["success"];
      } else {
        // res["msg"]
        return false;
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  deleteBoard(boardId) async {
    try {
      var res = await BoardProvider().delete(boardId);

      if (res["success"]) {
        return res["success"];
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
