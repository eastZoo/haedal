import 'package:get/get.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AuthProvider extends GetxController {
  onSignUp(data) async {
    return await ApiRequest(url: '${Endpoints.authUrl}/sign-up', data: data)
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
}
