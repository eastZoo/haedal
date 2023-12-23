import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class MemoProvider {
  create(data) async {
    return await ApiRequest(url: '${Endpoints.memoUrl}/create', data: data)
        .asyncPost();
  }

  getMemoList() async {
    return await ApiRequest(url: Endpoints.memoUrl).asyncGet();
  }
}
