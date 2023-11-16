import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class ImagesProvider {
  // 이미지 분석 전송 버튼
  create(data) async {
    return await ApiRequest(url: Endpoints.imageUrl, data: data).formPost();
  }
}
