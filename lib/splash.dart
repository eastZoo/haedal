import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/login_screen.dart';
import 'package:haedal/screens/main_screen.dart';
import 'package:haedal/screens/register_screen/code_screen.dart';
import 'package:haedal/screens/register_screen/info_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';

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
    const storage = FlutterSecureStorage();
    return FutureBuilder<String?>(
      future: storage.read(key: 'accessToken'),
      builder: (context, snapshot) {
        return GetBuilder<AuthController>(
            init: AuthController(),
            builder: (authCon) {
              // snapshot.data => accessToken
              // snapshot.hasData => token 있으면 true
              print("SPLASH@!!!!!!!!!!!!!!");
              print(authCon.connectState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                if (authCon.connectState == RxInt(0)) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (authCon.connectState == RxInt(1)) {
                  return const CodeScreen();
                } else if (authCon.connectState == RxInt(2)) {
                  return const InfoScreen();
                } else if (authCon.connectState == RxInt(3)) {
                  return const MainScreen();
                }
              }

              return const LoginScreen();
            });
      },
    );
  }
}
