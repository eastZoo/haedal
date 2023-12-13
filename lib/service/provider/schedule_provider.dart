import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class ScheduleProvider {
  create(data) async {
    return await ApiRequest(url: '${Endpoints.boardUrl}/create', data: data)
        .formPost();
  }
}
