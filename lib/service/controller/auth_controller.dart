import 'dart:async';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/couple_connect_info.dart';
import 'package:haedal/models/social_user_info.dart';
import 'package:haedal/models/couple_info.dart';
import 'package:haedal/service/provider/auth_provider.dart';
import 'package:haedal/utils/toast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  CoupleConnectInfo? coupleConnectInfo;

  late bool isDuplicateEmail;
  late Timer timer;

  late RxInt connectState = 0.obs;

  // 24시간 초단위 환산
  int accessCodeTimer = 86400;

// user profile info
  CoupleInfo? coupleInfo;
  bool isLoading = true;

  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'accessToken');
    print(token);
    var result = await getConnectState();
    // 상태코드 1번 회원가입 절차중 초대코드( 타이머 작동 ) 입력 단계
    if (result == 1) {
      await getInviteCodeInfo();
    }
    // 토큰이 없다면 사용자 프로필 얻어오지 않는다
    if (token != null) {
      getUserInfo();
    }
  }

  // 회원가입 함수
  onSignUp(userEmail, password, provider) async {
    Map<String, dynamic> dataSource = {
      "userEmail": userEmail,
      "password": password,
      "provider": provider
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().onSignUp(dataSource);
      if (res["data"]["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);
        connectState = RxInt(res["data"]["connectState"]);

        update();
        return res["success"];
      } else {
        CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (e) {
      print(e);
    }
  }

  /// 카카오톡 회원가입 , 로그인 함수
  onSocialKaKaoSignUp(User user, String provider) async {
    String birthDate = "";
    String? birthMonth;
    String? birthDay;

    // birthyear와 birthday를 조합하여 YYYY-MM-DD 형식의 날짜 문자열 생성
    var birthyear = user.kakaoAccount?.birthyear.toString();
    var birthday = user.kakaoAccount?.birthday.toString();
    if (birthyear != null && birthday != null) {
      // birthday를 MM-DD 형식으로 분리
      birthMonth = birthday.substring(0, 2);
      birthDay = birthday.substring(2, 4);

      // 최종 날짜 문자열 생성
      birthDate = '$birthyear-$birthMonth-$birthDay';
    }

    // 데이터 없을 때 빈 값 처리
    Map<String, dynamic> dataSource = {
      "userEmail": user.kakaoAccount?.email ?? "",
      "provider": provider,
      "providerUserId": user.id,
      "name": user.kakaoAccount?.name ?? "",
      "sex": user.kakaoAccount?.gender != null
          ? user.kakaoAccount?.gender.toString() == "Gender.male"
              ? "1"
              : "0"
          : "",
      "birth": birthDate ?? "",
      "profileUrl": user.kakaoAccount?.profile?.thumbnailImageUrl ?? "",
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().socialLoginRegister(dataSource);
      if (res["data"]["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);

        connectState = RxInt(res["data"]["connectState"]);

        update();

        return res["data"]["success"];
      } else {
        CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (e) {
      CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      print("error $e");
    }
  }

  /// 네이버 회원가입 , 로그인 함수
  onSocialNaverSignUp(NaverAccountResult user, String provider) async {
    String birthDate;

    var birthyear = user.birthyear.toString();
    var birthday = user.birthday.toString();

    // 최종 날짜 문자열 생성
    birthDate = '$birthyear-$birthday';

    print(user);
    // 데이터 없을 때 빈 값 처리
    Map<String, dynamic> dataSource = {
      "userEmail": user.email ?? "",
      "provider": provider,
      "providerUserId": user.id,
      "name": user.name ?? "",
      "sex": user.gender != null
          ? user.gender.toString() == "M"
              ? "1"
              : "0"
          : "",
      "birth": birthDate ?? "",
      "profileUrl": user.profileImage ?? "",
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().socialLoginRegister(dataSource);
      if (res["data"]["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);

        connectState = RxInt(res["data"]["connectState"]);

        update();

        return res["data"]["success"];
      } else {
        CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (e) {
      CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      print("error $e");
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
      print(res);
      print("getConnectState : ${res["data"]}");
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

      if (res["success"]) {
        coupleInfo = CoupleInfo.fromJson(res["data"]);
        print("coupleInfo : $coupleInfo");
      }

      print("coupleInfo : $coupleInfo");
      isLoading = false;
    } catch (error) {
      print("getUserInfo $error");
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
