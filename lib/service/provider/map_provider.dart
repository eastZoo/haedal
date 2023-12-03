import 'package:get/get.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class MapProvider {
  getLocation() async {
    return await ApiRequest(url: Endpoints.locationUrl).asyncGet();
  }
}
