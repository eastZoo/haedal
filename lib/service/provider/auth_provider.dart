import 'package:get/get.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AuthProvider extends GetxController {
  onSignUp(data) async {
    return await ApiRequest(url: '${Endpoints.authUrl}/sign-up', data: data)
        .ayncPost();
  }

  // 중복이메일 확인
  getDuplicateEmailState(String userEmail) async {
    print(userEmail);
    return await ApiRequest(url: '${Endpoints.authUrl}/check-id/$userEmail')
        .ayncGet();
  }

  // 현재 연결 진행사항 GET
  getConnectState() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/check-state').ayncGet();
  }
}
