import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class BoardProvider {
  create(data) async {
    return await ApiRequest(url: '${Endpoints.boardUrl}/create', data: data)
        .formPost();
  }

  delete(boardId) async {
    return await ApiRequest(url: '${Endpoints.boardUrl}/delete/$boardId')
        .asyncDelete();
  }
}
