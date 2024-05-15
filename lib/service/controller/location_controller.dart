import 'package:get/get.dart';
import 'package:haedal/service/provider/location_provider.dart';

class LocationController extends GetxController {
  getGeoLocation(lat, lon) async {
    var res = await LocationProvider().getGeoLocation(lon, lat);
    if (res["data"]["status"]["code"] == 0) {
      var si = res["data"]["results"][0]['region']['area1']['name'];
      var gu = res["data"]["results"][0]['region']['area2']['name'];
      var dong = res["data"]["results"][0]['region']['area3']['name'];
      var ro = res["data"]["results"][0]['land']['name'];
      var name = res["data"]["results"][0]['land']['addition0']['value'];

      String gusi = "$si $gu $dong $ro $name";
      return gusi;
    }
    if (res["data"]["status"]["code"] == 3) {
      String msg = "주소데이터를 찾을 수 없는 위치.";
      return msg;
    }
  }

  getAddressFromCoordinates(lat, lon) async {
    var res = await LocationProvider().getAddressFromCoordinates(lon, lat);

    print("kakao GEOCODING");
    print(res);
    if (res["data"]["meta"]["total_count"] != 0) {
      // 도로명 주소가 없을때
      if (res["data"]["documents"][0]['road_address'] == null) {
        var address = res["data"]["documents"][0]['address']['address_name'];
        var dataSource = {
          "addressName": address,
          "address": address,
        };
        return dataSource;
      }

      // 지번주소가 없을때
      if (res["data"]["documents"][0]['address'] == null) {
        var addressName =
            res["data"]["documents"][0]['road_address']['address_name'];
        var dataSource = {
          "addressName": addressName,
          "address": addressName,
        };
        return dataSource;
      }
      // 도로명 주소
      var addressName =
          res["data"]["documents"][0]['road_address']['address_name'];
      // 지번 주소
      var address = res["data"]["documents"][0]['address']['address_name'];

      var dataSource = {
        "addressName": addressName,
        "address": address,
      };

      return dataSource;
    }
    if (res["data"]["meta"]["total_count"] == 0) {
      String msg = "주소데이터를 찾을 수 없는 위치.";
      return msg;
    }
  }

  // createMyLocation(data) async {
  //   await LocationProvider().createMyLocation(data);
  // }
}
