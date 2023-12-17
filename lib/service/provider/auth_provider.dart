import 'package:get/get.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AuthProvider extends GetxController {
  // 회원가입
  onSignUp(data) async {
    return await ApiRequest(url: '${Endpoints.authUrl}/sign-up', data: data)
        .asyncPost();
  }

  // 로그인
  onSignIn(data) async {
    return await ApiRequest(url: '${Endpoints.authUrl}/sign-in', data: data)
        .asyncPost();
  }

  // 회원가입 취소
  onCancelSignUp(data) async {
    return await ApiRequest(
            url: '${Endpoints.authUrl}/sign-up/cancel', data: data)
        .asyncPost();
  }

  // 중복이메일 확인
  getDuplicateEmailState(String userEmail) async {
    return await ApiRequest(url: '${Endpoints.authUrl}/check-id/$userEmail')
        .asyncGet();
  }

  // 현재 연결 진행사항 GET
  getConnectState() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/check-state').asyncGet();
  }

  // 초대코드 , 커플 정보 얻기
  getInviteCodeInfo() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/invite-code').asyncGet();
  }

// 초대코드 리프래쉬
  refreshInviteCode() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/invite-code/refresh')
        .asyncGet();
  }

// 초대코드 연결
  onConnect(data) async {
    return await ApiRequest(
            url: '${Endpoints.authUrl}/code/connect', data: data)
        .asyncPost();
  }

  // 개인정보 입력 최종 연결 요청
  onStartConnect(data) async {
    return await ApiRequest(
            url: '${Endpoints.authUrl}/info/connect', data: data)
        .asyncPost();
  }

  getUserInfoProvider() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/profile').asyncGet();
  }
}
