import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class LocationProvider {
  getGeoLocation(lon, lat) async {
    return await ApiRequest(
            url:
                'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&orders=roadaddr&output=json')
        .asyncGet();
  }
}
