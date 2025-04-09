import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/couple_connect_info.dart';
import 'package:haedal/models/social_user_info.dart';
import 'package:haedal/models/couple_info.dart';
import 'package:haedal/service/provider/auth_provider.dart';
import 'package:haedal/utils/toast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  CoupleConnectInfo? coupleConnectInfo;

  late bool isDuplicateEmail;
  late Timer timer;

  late RxInt connectState = 0.obs;

  // 24시간 초단위 환산
  // timer 관련 변수들을 별도의 observable로 관리
  final _accessCodeTimer = 86400.obs;

  int get accessCodeTimer => _accessCodeTimer.value;
  set accessCodeTimer(int value) => _accessCodeTimer.value = value;

// user profile info
  // user profile info
  var coupleInfo = Rx<CoupleInfo?>(null);
  bool isLoading = true;

  @override
  void onInit() async {
    super.onInit();
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'accessToken');
    print(token);
    try {
      var result = await getConnectState();
      // 상태코드 1번 회원가입 절차중 초대코드( 타이머 작동 ) 입력 단계
      if (result == 1) {
        await getInviteCodeInfo();
      }
      // 토큰이 없다면 사용자 프로필 얻어오지 않는다
      if (token != null) {
        getUserInfo();
      }
    } catch (e) {
      print(e);
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
      if (res["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);
        connectState.value = res["data"]["connectState"];

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
      if (res["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);
        storage.write(key: "refreshToken", value: res["data"]["refreshToken"]);

        connectState.value = res["data"]["connectState"];

        update();

        return res["success"];
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
      "birth": birthDate,
      "profileUrl": user.profileImage ?? "",
    };
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().socialLoginRegister(dataSource);
      if (res["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);
        storage.write(key: "refreshToken", value: res["data"]["refreshToken"]);

        connectState = RxInt(res["data"]["connectState"]);

        update();

        return res["success"];
      } else {
        CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
        return res["success"];
      }
    } catch (e) {
      CustomToast().alert("서버에러 회원가입에 실패했습니다. 다시 시도해주세요.");
      print("error $e");
    }
  }

  /// 네이버 회원가입 , 로그인 함수
  onSocialAppleSignUp(
      AuthorizationCredentialAppleID user, String provider) async {
    // 데이터 없을 때 빈 값 처리
    Map<String, dynamic> dataSource = {
      "userEmail": user.email ?? "",
      "provider": provider,
      "providerUserId": user.userIdentifier,
      "name": "${user.familyName}${user.givenName}" ?? "",
      "sex": "",
      "birth": null,
      "profileUrl": "",
    };

    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().socialLoginRegister(dataSource);
      if (res["success"]) {
        // 로그인 후 응답으로 부터 토큰 저장
        storage.write(key: "accessToken", value: res["data"]["accessToken"]);
        storage.write(key: "refreshToken", value: res["data"]["refreshToken"]);

        connectState.value = res["data"]["connectState"];

        update();

        return res["success"];
      } else {
        CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
        return res["success"];
      }
    } catch (e) {
      CustomToast().alert("서버에러회원가입에 실패했습니다. 다시 시도해주세요.");
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

    if (res["success"]) {
      // 로그인 후 응답으로 부터 토큰 저장
      storage.write(key: "accessToken", value: res["data"]["accessToken"]);
      storage.write(key: "refreshToken", value: res["data"]["refreshToken"]);
      connectState.value = res["data"]["connectState"];
      update();

      return res;
    }
    return res;
  }

  // 초대코드 연결
  onConnect(String code) async {
    Map<String, dynamic> dataSource = {
      "code": code,
    };
    var res = await AuthProvider().onConnect(dataSource);
    if (res["success"]) {
      // 상태저장 => 2

      connectState.value = res["data"]["connectState"];
      update();
      return res;
    }
    return res;
  }

  // 중복이메일 확인
  checkDuplicateEmail(String userEmail) async {
    var res = await AuthProvider().getDuplicateEmailState(userEmail);
    isDuplicateEmail = res["data"] == true ? true : false;
    update();
  }

  // 현재 커플과 연결 상태 (1: 승인코드 미입력 , 2:개인정보 미입력, 3:모두입력)
  getConnectState() async {
    try {
      print("🚩 getConnectState init");
      const storage = FlutterSecureStorage();
      var token = await storage.read(key: "accessToken");

      print("🚩 getConnectState token : $token");
      // 토큰이 있을때만 연결상태 GET API 실행
      if (token != null) {
        var res = await AuthProvider().getConnectState();
        print("🚩 getConnectState res : $res");
        print("🚩 getConnectState res : ${res["data"]}");
        print("🚩 getConnectState res : ${res["success"]}");
        if (res["data"] == false) {
          return await logOut();
        }
        // if (res["data"] == 3) {
        //   return Navigator.pushNamed(Get.context!, '/home');
        // }

        print("resConnectState : $res");

        connectState.value = res["data"];
        update();
        return res["data"];
      }
    } catch (e) {
      print(e);
    }
  }

  // 승인코드 얻기 ( 승인코드 처리 )
  getInviteCodeInfo() async {
    print("getInviteCodeInfo");
    if (connectState == 1) {
      var res = await AuthProvider().getInviteCodeInfo();
      print("getInviteCodeInfo res : $res");
      if (res["success"]) {
        print(res["data"]);
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
    if (_accessCodeTimer.value <= 0) {
      timer.cancel(); // 현재 타이머 중지
      refreshInviteCode(); // 새로운 초대코드 요청
    } else {
      _accessCodeTimer.value =
          (targetTimeStamp - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    }
  }

  // 초대코드 리프레쉬
  refreshInviteCode() async {
    try {
      var res = await AuthProvider().refreshInviteCode();
      if (res["success"]) {
        // 새로운 초대코드 정보로 업데이트
        coupleConnectInfo = CoupleConnectInfo.fromJson(res["data"]);

        // 새로운 타임스탬프 계산
        int newTargetTimeStamp = coupleConnectInfo?.updatedAt
                ?.add(const Duration(hours: 24))
                .millisecondsSinceEpoch ??
            0;

        // 타이머 초기화 및 재시작
        _accessCodeTimer.value = 86400;
        onStartTimer(newTargetTimeStamp);

        update();
      } else {
        CustomToast().alert("초대코드 갱신에 실패했습니다.");
      }
    } catch (e) {
      print("refreshInviteCode error: $e");
      CustomToast().alert("초대코드 갱신 중 오류가 발생했습니다.");
    }
  }

// 개인정보 입력 최종 연결 요청
  onStartConnect(dataSource) async {
    var res = await AuthProvider().onStartConnect(dataSource);
    if (res["success"]) {
      connectState.value = res["data"]["connectState"];
      update();
      return res["success"];
    }
  }

  // 아이디 찾기 버튼
  onFindId(dataSource) async {
    try {
      var res = await AuthProvider().onFindId(dataSource);

      if (res["success"]) {
        return true;
      }
    } catch (e) {
      CustomToast().alert("아이디 찾기에 실패했습니다. 다시 시도해주세요.");
      print(e);
    }
  }

  // 유저 프로필 가져오기
  getUserInfo() async {
    try {
      var res = await AuthProvider().getUserInfoProvider();
      if (res["success"]) {
        coupleInfo.value = CoupleInfo.fromJson(res["data"]);
      }
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

    // 1. 타이머 정리
    if (timer.isActive) {
      timer.cancel();
    }

    // 2. 타이머 관련 상태 초기화
    _accessCodeTimer.value = 86400;
    coupleConnectInfo = null;

    // 3. 저장소 및 상태 초기화
    const storage = FlutterSecureStorage();
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken"); // refresh 토큰도 삭제

    // 4. 상태 초기화
    connectState.value = 0;
    coupleInfo.value = null;
    isLoading = false;

    // 5. GetX 상태 업데이트
    update();
  }

// 배경화면 이미지 업로드
  uploadHomeImage(requestData) async {
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().uploadHomeImage(requestData);
      if (res["success"]) {
        return res["success"];
      } else {
        CustomToast().alert("이미지 업로드에 실패했습니다.");
      }
    } catch (e) {
      print(e);
    }
  }

// 배경화면 이미지 업로드
  uploadProfileImage(requestData) async {
    try {
      // 회원가입(로그인) API
      var res = await AuthProvider().uploadProfileImage(requestData);
      if (res["success"]) {
        return res["success"];
      } else {
        CustomToast().alert("이미지 업로드에 실패했습니다.");
      }
    } catch (e) {
      print(e);
    }
  }

  deleteUser() async {
    try {
      var res = await AuthProvider().deleteUser();
      if (res["success"]) {
        logOut();
        return res["success"];
      } else {
        CustomToast().alert("회원탈퇴에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (e) {
      print(e);
    }
  }
}
