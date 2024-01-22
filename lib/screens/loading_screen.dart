import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/widgets/app_button.dart';

class LoadingScreen extends StatefulWidget {
  String? token;
  RxInt? connectState;
  LoadingScreen({super.key, this.token, this.connectState});

  @override
  State<LoadingScreen> createState() =>
      _LoadingScreenState(token, connectState);
}

class _LoadingScreenState extends State<LoadingScreen> {
  _LoadingScreenState(this.token, this.connectState);

  final authCon = Get.put(AuthController());

  String? token;
  RxInt? connectState;
  @override
  void initState() {
    super.initState();
  }

  void checkAutoLogout(token, connectState) async {
    print("IN checkAutoLogout");
    print("IN checkAutoLogout $token, $connectState");
    await Future.delayed(const Duration(seconds: 4));
    /** 로딩 시 디폴트값 0 으로 인해서 자동 로그아웃 되는 이슈 발생 , 디폴트 값을 바꾸던지, 토큰이 잘못된 토큰일 때 날릴 변수 설정 필요!! */
    // Check if user is logged in
    if (token!.isNotEmpty && connectState == 0) {
      authCon.logOut();
      print("AUTO LOGOUT");
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            const CircularProgressIndicator(),
            InkWell(
              onTap: () {
                checkAutoLogout(token, connectState);
              },
              child: const AppButton(text: "logout"),
            )
          ],
        ),
      ),
    );
  }
}
