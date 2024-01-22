import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class MemoProvider {
  // 메모 생성
  create(data) async {
    return await ApiRequest(url: '${Endpoints.memoUrl}/create', data: data)
        .asyncPost();
  }

  // 모든 메모 리스트 정보 얻기
  getMemoList() async {
    return await ApiRequest(url: Endpoints.memoUrl).asyncGet();
  }

  // 메모리스트 상세보기
  getDetailMemo(id) async {
    return await ApiRequest(url: '${Endpoints.memoUrl}/$id').asyncGet();
  }
}
