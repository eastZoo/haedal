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

  getLabelColor() async {
    return await ApiRequest(url: '${Endpoints.caledarUrl}/color').asyncGet();
  }

  getCurrentWorkTableUrl(currentMonth) async {
    return await ApiRequest(
            url: '${Endpoints.caledarUrl}/work-table?_month=$currentMonth')
        .asyncGet();
  }

  workTableSubmit(data) async {
    return await ApiRequest(
            url: '${Endpoints.caledarUrl}/work-table/create', data: data)
        .formPost();
  }
}
