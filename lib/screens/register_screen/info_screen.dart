import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          // 로그아웃
          void logOut() {
            const storage = FlutterSecureStorage();
            storage.delete(key: "accessToken");

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // logo
                      Image.asset(
                        "assets/icons/register-3.png",
                      ),

                      const SizedBox(height: 15),

                      // welcome back, you've been missed!
                      Text(
                        '연결성공!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),
                      Text(
                        '프로필을 입력해주세요',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: inviteCodeController,
                        hintText: '이름',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: inviteCodeController,
                        hintText: '생일 (만 14세 이상 사용가능)',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: inviteCodeController,
                        hintText: '처음 만난 날 (선택입력)',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),
                      MyButton(title: "시작하기", onTap: () {}, available: true),

                      const SizedBox(height: 10),
                      MyButton(title: "로그아웃", onTap: logOut, available: true),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
