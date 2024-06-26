import 'package:haedal/service/api_request.dart';
import 'package:haedal/service/endpoints.dart';

class MemoProvider {
  // 메모 카테고리 생성
  createMemoCategory(data) async {
    return await ApiRequest(
            url: '${Endpoints.memoUrl}/category/create', data: data)
        .asyncPost();
  }

  // 메모 생성
  createMemo(data) async {
    print(" $data data");
    return await ApiRequest(url: '${Endpoints.memoUrl}/create', data: data)
        .asyncPost();
  }

// 메모 체크박스 업데이트
  updateMemoItem(data) async {
    return await ApiRequest(
            url: '${Endpoints.memoUrl}/update/check', data: data)
        .asyncPost();
  }

  // 모든 메모 리스트 정보 얻기
  getMemoList() async {
    return await ApiRequest(url: Endpoints.memoUrl).asyncGet();
  }

  // 메모리스트 상세보기
  getDetailMemo(id) async {
    return await ApiRequest(url: '${Endpoints.memoUrl}/detail/$id').asyncGet();
  }
}
