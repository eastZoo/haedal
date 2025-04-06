import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRequest {
  final String url;
  final Map<String, dynamic>? data;
  final FormData? formData;
  final storage = const FlutterSecureStorage();

  ApiRequest({
    required this.url,
    this.data,
    this.formData,
  });

  Future<Dio> _dio() async {
    String? token = await storage.read(key: 'accessToken');
    return Dio(
      BaseOptions(
        headers: {
          'Authorization': 'Bearer $token',
          'X-NCP-APIGW-API-KEY-ID':
              dotenv.env['NAVER_CLIENT_ID'], // 개인 클라이언트 아이디
          'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_SECRET_ID'],
        },
      ),
    );
  }

  /// 카카오 리버스지오코당을 위한 Authorization 세팅
  Future<Dio> _kakaoDio() async {
    print('KakaoAK ${dotenv.env['KAKAO_MAP_REST_API_KEY']}');
    return Dio(
      BaseOptions(
        headers: {
          'Authorization': 'KakaoAK ${dotenv.env['KAKAO_MAP_REST_API_KEY']}',
        },
      ),
    );
  }

  asyncGet() async {
    try {
      var dio = await _dio();
      Response response = await dio.get(url, queryParameters: data);
      return response.data;
    } on Exception catch (e) {
      print(e);

      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = "오류발생 내용을 다시 확인해 주세요.";
        // errorMsg =
        //     e.response?.data["message"].toString() ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 네이버 리버스 지오코딩 get
  asyncGeoGet() async {
    try {
      var dio = await _kakaoDio();
      print(url);
      Response response = await dio.get(url, queryParameters: data);
      print(response);
      return {
        "success": true,
        "data": response.data,
      };
    } on Exception catch (e) {
      print("에러 $e,");

      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = "오류발생 내용을 다시 확인해 주세요.";
        // errorMsg =
        //     e.response?.data["message"].toString() ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  asyncPost() async {
    try {
      var dio = await _dio();
      Response response =
          await dio.post(url, data: data, queryParameters: data);
      return response.data;
    } catch (e) {
      print(e);
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  asyncDelete() async {
    try {
      var dio = await _dio();
      Response response = await dio.delete(url, data: data);
      return response.data;
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  formPost() async {
    try {
      var dio = await _dio();
      Response response = await dio.post(url,
          data: FormData.fromMap(data ?? {}),
          options: Options(headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json',
          }));

      return response.data;
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        print(e);
        errorMsg =
            e.response?.data["message"].toString() ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }
}

/// 애플 탈퇴를 위한 세팅
Future<Dio> _appleDio() async {
  return Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ),
  );
}

Future<void> revokeAppleTokenAPI(
  String clientId,
  String clientSecret,
  String token,
  String tokenTypeHint,
) async {
  const url = 'https://appleid.apple.com/auth/revoke';
  var dio = await _appleDio();
  Response response = await dio.post(url, data: {
    'client_id': clientId,
    'client_secret': clientSecret,
    'token': token,
    'token_type_hint': tokenTypeHint,
  });

  if (response.statusCode == 200) {
    // 토큰이 성공적으로 무효화됨
    print('Token revoked successfully');
  } else {
    // 오류 발생
    print('Failed to revoke token: ${response.statusCode}');
  }
}
