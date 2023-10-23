import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:haedal/screens/login_screen.dart';
import 'package:haedal/models/user.dart';
import 'package:haedal/screens/main_screen.dart';
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
    const storage = FlutterSecureStorage();

    return FutureBuilder<String?>(
      future: storage.read(key: 'access_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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

          return const MainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
