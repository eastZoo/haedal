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
    String? token = await storage.read(key: 'access_token');
    return Dio(
      BaseOptions(
        headers: {
          'authorization': 'Bearer $token',
          'X-NCP-APIGW-API-KEY-ID':
              dotenv.env['NAVER_CLIENT_ID'], // 개인 클라이언트 아이디
          'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_SECRET_ID']
        },
      ),
    );
  }

  ayncGet() async {
    try {
      var dio = await _dio();
      Response response = await dio.get(url, queryParameters: data);
      return {
        "success": true,
        "data": response.data,
      };
    } on Exception catch (e) {
      print(e);

      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioError) {
        errorMsg = "오류발생 내용을 다시 확인해 주세요.";
        // errorMsg =
        //     e.response?.data["message"].toString() ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  ayncPost() async {
    try {
      var dio = await _dio();
      Response response =
          await dio.post(url, data: data, queryParameters: data);
      return {"success": true, "data": response.data};
    } catch (e) {
      print(e);
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioError) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  ayncDelete() async {
    try {
      var dio = await _dio();
      Response response = await dio.delete(url, data: data);
      return {
        "success": true,
        "data": response.data,
      };
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioError) {
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

      return {"success": true, "data": response.data};
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioError) {
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
