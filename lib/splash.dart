import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/models/user.dart';
import 'package:haedal/screens/login_screen.dart';
import 'package:haedal/screens/main_screen.dart';
import 'package:haedal/screens/register_screen/code_screen.dart';
import 'package:haedal/screens/register_screen/info_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:jwt_decode/jwt_decode.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authCon = Get.put(AuthController());
    const storage = FlutterSecureStorage();
    return FutureBuilder<String?>(
      future: storage.read(key: 'accessToken'),
      builder: (context, snapshot) {
        return GetBuilder<AuthController>(
            init: AuthController(),
            builder: (authCon) {
              print('$authCon.connectState');
              if (snapshot.connectionState == ConnectionState.waiting ||
                  authCon.connectState == 0) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                Map<String, dynamic> payload =
                    Jwt.parseJwt(snapshot.data?.toString() ?? "");
                var user = User.fromJson(payload);
                String userId = user.userId ?? "";

                if (authCon.connectState == 1) {
                  return const CodeScreen();
                } else if (authCon.connectState == 2) {
                  return const InfoScreen();
                }
                return const MainScreen();
              } else {
                return LoginScreen();
              }
            });
      },
    );
  }
}
