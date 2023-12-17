import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/couple_connect_info.dart';
import 'package:haedal/models/user_info.dart';
import 'package:haedal/service/provider/auth_provider.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  CoupleConnectInfo? coupleConnectInfo;

  late bool isDuplicateEmail;
  late Timer timer;

  late RxInt connectState = 0.obs;

  // 24시간 초단위 환산
  int accessCodeTimer = 86400;

// user profile info
  UserInfo? userInfo;
  bool isLoading = true;

  @override
  void onInit() async {
    super.onInit();
    print("ONINIT!!!");
    var result = await getConnectState();
    print("ONINIT result : $result");
    // 상태코드 1번 회원가입 절차중 초대코드( 타이머 작동 ) 입력 단계
    if (result == 1) {
      await getInviteCodeInfo();
    }
    getUserInfo();
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
    // 회원가입(로그인) API
    var res = await AuthProvider().onSignIn(dataSource);

    if (res["data"]["success"]) {
      // 로그인 후 응답으로 부터 토큰 저장
      storage.write(key: "accessToken", value: res["data"]["accessToken"]);
      storage.write(key: "refreshToken", value: res["data"]["refreshToken"]);
      connectState = RxInt(res["data"]["connectState"]);
      update();
      return res["data"];
    }
    return res["data"];
  }

  // 초대코드 연결
  onConnect(String code) async {
    Map<String, dynamic> dataSource = {
      "code": code,
    };
    var res = await AuthProvider().onConnect(dataSource);
    if (res["data"]["success"]) {
      // 상태저장 => 2
      print(res["data"]["connectState"].runtimeType);
      print("onConnect");
      connectState = RxInt(res["data"]["connectState"]);
      update();
      return res["data"];
    }
    return res["data"];
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

      print("getConnectState");
      print(res["data"]);
      print(res["data"].runtimeType);
      if (res["data"] == "false") {
        return await logOut();
      }
      connectState = RxInt(int.parse(res["data"]));
      update();
      return int.parse(res["data"]);
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
      print(res["data"]["connectState"].runtimeType);
      connectState = RxInt(int.parse(res["data"]["connectState"]));

      update();
      return res["data"]["success"];
    }
  }

  // 유저 프로필 가져오기
  getUserInfo() async {
    try {
      var res = await AuthProvider().getUserInfoProvider();
      print("USERINFO   : : $res");
      userInfo = UserInfo.fromJson(res["data"]);

      print("USERINFO   : : $userInfo");
      isLoading = false;
    } catch (error) {
      // error 캐치해도 일단 아바타 로딩 잡기 위해서 강제 false 처리
      isLoading = false;
    } finally {
      update();
    }
  }

  // 로그아웃
  logOut() async {
    print("로그아웃!!!!!!");
    const storage = FlutterSecureStorage();
    storage.delete(key: "accessToken");

    connectState.update(RxInt(0));
  }
}
