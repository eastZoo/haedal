import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class ScheduleProvider {
  create(data) async {
    return await ApiRequest(url: '${Endpoints.caledarUrl}/create', data: data)
        .asyncPost();
  }

  getSchedule() async {
    return await ApiRequest(
      url: Endpoints.caledarUrl,
    ).asyncGet();
  }
}
