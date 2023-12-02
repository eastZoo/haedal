import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class InfiniteScrollProvider {
  albumListGenerate(offset) async {
    return await ApiRequest(url: '${Endpoints.boardUrl}?_offset=$offset')
        .asyncGet();
  }
}
