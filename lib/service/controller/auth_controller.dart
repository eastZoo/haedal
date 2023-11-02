import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/couple_connect_info.dart';
import 'package:haedal/service/provider/auth_provider.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  CoupleConnectInfo? coupleConnectInfo;

  late bool isDuplicateEmail;
  late Timer timer;

  late RxInt connectState = 0.obs;

  // 24시간 초단위 환산
  int accessCodeTimer = 86400;

  @override
  void onInit() async {
    super.onInit();
    print("ONINIT!!!");
    var result = await getConnectState();
    print("ONINIT result : $result");
    if (result != null) {
      await getInviteCodeInfo();
    }
  }

  // 회원가입
  onSignUp(userEmail, password) async {
    Map<String, dynamic> dataSource = {
      "userEmail": userEmail,
      "password": password,
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().onSignUp(dataSource);
      // 로그인 후 응답으로 부터 토큰 저장
      storage.write(key: "accessToken", value: res["data"]["accessToken"]);
      connectState = res["data"]["connectState"];

      update();
      return res["success"];
    } catch (e) {
      print(e);
    }
  }

  //로그인
  onSignIn(userEmail, password) async {
    Map<String, dynamic> dataSource = {
      "userEmail": userEmail,
      "password": password,
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().onSignIn(dataSource);

      print("res[" "]");
      print(res["data"]);
      // 로그인 후 응답으로 부터 토큰 저장
      storage.write(key: "accessToken", value: res["data"]["accessToken"]);
      connectState = RxInt(int.parse(res["data"]["connectState"]));

      update();
      return res["success"];
    } catch (e) {
      print(e);
    }
  }

  // 초대코드 연결
  onConnect(String code) async {
    Map<String, dynamic> dataSource = {
      "code": code,
    };
    var res = await AuthProvider().onConnect(dataSource);
  }

  // 중복이메일 확인
  checkDuplicateEmail(String userEmail) async {
    var res = await AuthProvider().getDuplicateEmailState(userEmail);
    isDuplicateEmail = res["data"] == "true" ? true : false;
    update();
  }

  // 현재 커플과 연결 상태 (1: 승인코드 미입력 , 2:개인정보 미입력, 3:모두입력)
  getConnectState() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    // 토큰이 있을때만 연결상태 GET API 실행
    if (token != null) {
      var res = await AuthProvider().getConnectState();

      print("getConnectState res :   ${res["data"]}");

      connectState = RxInt(int.parse(res["data"]));
      update();
      return res["success"];
    }
  }

  // 승인코드 얻기 ( 승인코드 처리 )
  getInviteCodeInfo() async {
    print("getInviteCodeInfo : $connectState");
    if (connectState == 1) {
      var res = await AuthProvider().getInviteCodeInfo();
      if (res["success"]) {
        print("getInviteCodeInfo res: ${res["data"]}");
        coupleConnectInfo = CoupleConnectInfo.fromJson(res["data"]);
        int targetTimeStamp = coupleConnectInfo?.updatedAt
                ?.add(const Duration(hours: 24))
                .millisecondsSinceEpoch ??
            0;
        onStartTimer(targetTimeStamp);
      } else {
        throw Error();
      }
    }
  }

  void onStartTimer(int targetTimeStamp) {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        onTick(timer, targetTimeStamp);
      },
    );
  }

  void onTick(Timer timer, int targetTimeStamp) {
    if (accessCodeTimer == 0) {
      refreshInviteCode();
      timer.cancel();
    } else {
      accessCodeTimer =
          (targetTimeStamp - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
      update();
    }
  }

  // 초대코드 리프레쉬
  refreshInviteCode() async {
    timer.cancel();
    await AuthProvider().refreshInviteCode();
    accessCodeTimer = 86400;
    update();
  }

// 개인정보 입력 최종 연결 요청
  onStartConnect(dataSource) async {
    var res = await AuthProvider().onStartConnect(dataSource);
    print("onStartConnect  : ${res["data"]}");
    if (res["data"]["success"]) {
      print(res["data"]["success"].runtimeType);
      connectState = RxInt(res["data"]["connectState"]);

      return res["data"]["success"];
    }
  }
}
