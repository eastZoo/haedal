import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/service/provider/auth_provider.dart';

class AuthController extends GetxController {
  late bool isDuplicateEmail;
  int connectState = 0;

  @override
  void onInit() async {
    super.onInit();
    await getConnectState();
  }

  onSignUp(userEmail, password) async {
    const storage = FlutterSecureStorage();
    Map<String, dynamic> dataSource = {
      "userEmail": userEmail,
      "password": password,
    };
    try {
      var res = await AuthProvider().onSignUp(dataSource);
      print(res["data"]);
      storage.write(key: "accessToken", value: res["data"]["accessToken"]);
      return res["data"]["success"];
    } catch (e) {
      print(e);
    }
  }

  // 중복이메일 확인
  checkDuplicateEmail(String userEmail) async {
    var res = await AuthProvider().getDuplicateEmailState(userEmail);

    isDuplicateEmail = res["data"] == "true" ? true : false;
    update();
  }

// 현재 커플과 연결 상태 (1: 승인코드 미입력 , 2:개인정보 미입력, 3:모두입력)
  getConnectState() async {
    var res = await AuthProvider().getConnectState();
    print(res["data"].runtimeType);
    print(res["data"]);
    print("getConnectStategetConnectStategetConnectStategetConnectState");

    connectState = int.parse(res["data"]);
    update();
  }
}
