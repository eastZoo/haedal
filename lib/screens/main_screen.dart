import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:haedal/widgets/my_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  logOut() {
    const storage = FlutterSecureStorage();
    storage.delete(key: "accessToken");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '미션 진행중',
                style: TextStyle(
                  color: Color(0xFF2E397C),
                  fontSize: 10,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.60,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              const Text(
                '걷기미션을 진행하고 있습니다!',
                style: TextStyle(
                  color: Color(0xFF2B2F45),
                  fontSize: 13,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.78,
                ),
              ),
              MyButton(title: "로그아웃", onTap: logOut, available: true),
            ],
          ),
        ),
      ]),
    );
  }
}
