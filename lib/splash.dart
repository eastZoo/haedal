import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/loading_screen.dart';
import 'package:haedal/screens/login_screen.dart';
import 'package:haedal/screens/main_screen.dart';
import 'package:haedal/screens/register_screen/code_screen.dart';
import 'package:haedal/screens/register_screen/info_screen.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authCon = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    return FutureBuilder<String?>(
      future: storage.read(key: 'accessToken'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Image.asset("assets/icons/logo.png"),
            ),
          );
        }

        final token = snapshot.data;

        // snapshot에 토큰이 있고 connectState가 옵저버블이므로 Obx로 감싸줍니다
        if (token != null && token.isNotEmpty) {
          return Obx(() {
            switch (authCon.connectState.value) {
              case 0:
                return LoadingScreen(
                    token: token, connectState: authCon.connectState);
              case 1:
                return const CodeScreen();
              case 2:
                return const InfoScreen();
              case 3:
                return const MainScreen();
              default:
                return const LoginScreen();
            }
          });
        }

        // token이 null이거나 빈 값이면 로그인 화면으로 이동
        return const LoginScreen();
      },
    );
  }
}
