// 나는 함수 반환형이 이렇게 되어있음. 필요한 방향으로 알아서 바꿔 사용하면 될 것 같다
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:haedal/service/api_request.dart';
import 'package:haedal/utils/toast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

revokeSignInWithApple() async {
  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final String authCode = appleCredential.authorizationCode;

    final String privateKey = [
      dotenv.env['APPLE_PRIVATE_KEY_LINE1']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE2']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE3']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE4']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE5']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE6']!,
    ].join('\n'); //이런띠바 여기 슬래시 하나 더 있어서 3시간을 날림 블로그써라

    const String teamId = '438R3J7434';
    const String clientId = 'com.eastzoo.haedal';
    const String keyId = 'U76G36482H';

    final String clientSecret = createJwt(
      teamId: teamId,
      clientId: clientId,
      keyId: keyId,
      privateKey: privateKey,
    );

    final accessToken = (await requestAppleTokens(
      authCode,
      clientSecret,
      clientId,
    ))['access_token'] as String;
    const String tokenTypeHint = 'access_token';

    await revokeAppleToken(
      clientId: clientId,
      clientSecret: clientSecret,
      token: accessToken,
      tokenTypeHint: tokenTypeHint,
    );

    return right(null);
  } on Exception catch (e) {
    CustomToast().alert('사용자 계정 삭제 중 오류 발생: $e');
    return;
  }
}

// JWT 생성 함수
String createJwt({
  required String teamId,
  required String clientId,
  required String keyId,
  required String privateKey,
}) {
  try {
    final jwt = JWT(
      {
        'iss': teamId,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
        'aud': 'https://appleid.apple.com',
        'sub': clientId,
      },
      header: {
        'kid': keyId,
        'alg': 'ES256',
      },
    );

    print("jwt: ${jwt.toString()}");

    final key = ECPrivateKey(privateKey);
    return jwt.sign(key, algorithm: JWTAlgorithm.ES256);
  } catch (e) {
    print('e key access ERROR: $e');
    throw Exception('Error creating JWT: $e');
  }
}

// 사용자 토큰 취소 함수
revokeAppleToken({
  required String clientId,
  required String clientSecret,
  required String token,
  required String tokenTypeHint,
}) async {
  final response = await revokeAppleTokenAPI(
    clientId,
    clientSecret,
    token,
    tokenTypeHint,
  );
}

requestAppleTokens(
  String authorizationCode,
  String clientSecret,
  String clientId,
) async {
  final dio = Dio();

  try {
    final response = await dio.post(
      'https://appleid.apple.com/auth/token',
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': authorizationCode,
        'grant_type': 'authorization_code',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('토큰 요청 실패: ${response.data}');
    }
  } catch (e) {
    throw Exception('토큰 요청 중 오류 발생: $e');
  }
}
