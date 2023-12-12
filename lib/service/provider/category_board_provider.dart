import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class CategoryBoardProvider {
  categoryListGenerate(offset, category) async {
    return await ApiRequest(
            url:
                '${Endpoints.boardUrl}/category?_offset=$offset&_category=$category')
        .asyncGet();
  }
}
