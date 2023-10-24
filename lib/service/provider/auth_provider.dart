import 'package:get/get.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class AuthProvider extends GetxController {
  onLogin() async {
    return await ApiRequest(url: '${Endpoints.authUrl}/main-notice').ayncGet();
  }
}
