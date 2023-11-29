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
      String msg = "별명을 입력해주세요.";
      return msg;
    }
  }

  // createMyLocation(data) async {
  //   await LocationProvider().createMyLocation(data);
  // }
}
