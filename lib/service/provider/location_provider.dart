import 'package:haedal/service/api_request.dart';

class LocationProvider {
  /// 네이버 리버스지오코딩
  getGeoLocation(lon, lat) async {
    return await ApiRequest(
            url:
                'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&orders=roadaddr&output=json')
        .asyncGet();
  }

  /// 카카오 리버스 지오코딩
  getAddressFromCoordinates(double latitude, double longitude) async {
    return await ApiRequest(
            url:
                'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$latitude&y=$longitude')
        .asyncGeoGet();
  }
}
