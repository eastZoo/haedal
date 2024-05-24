import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 이메일 텍스트 controllers
  FocusNode userEmailfocusNode = FocusNode();

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    // 이메일 커서 포커스 감지하는 함수 부착
    userEmailfocusNode.addListener(() {
      if (!userEmailfocusNode.hasFocus) {
        cursorMovedOutOfEmailTextField();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 이메일 텍스트필드에서 커서 Out 됬을때 실행되는 함수
  void cursorMovedOutOfEmailTextField() async {
    // 커서 아웃됬을때 공백 전부 삭제
    emailController.text = emailController.text.replaceAll(" ", "");
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200], // 배경색 설정
      ),
      child: IconButton(
        icon: SvgPicture.asset(iconPath, height: 30),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          return Scaffold(
            backgroundColor: AppColors().white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(140),
                      // logo
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 170,
                      ),

                      const SizedBox(height: 50),

                      // username textfield
                      MyTextField(
                        controller: emailController,
                        hintText: '이메일',
                        focusNode: userEmailfocusNode,
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: '비밀번호',
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      // sign in button
                      MyButton(
                        title: "로그인",
                        onTap: () async {
                          var result = await authCon.onSignIn(
                              emailController.text, passwordController.text);
                          if (result["success"]) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/splash',
                              (route) => false,
                            );
                          } else {
                            setState(() {
                              errorMsg = result["msg"];
                            });
                            return CustomToast().alert(errorMsg);
                          }
                        },
                        available: true,
                      ),

                      const SizedBox(height: 25),

                      // or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'SNS 계정으로 로그인',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildSocialButton('assets/icons/svg/icon-kakao.svg',
                              () {
                            // Handle Kakao login
                          }),
                          const SizedBox(width: 20),
                          _buildSocialButton('assets/icons/svg/icon-naver.svg',
                              () {
                            // Handle Naver login
                          }),
                          const SizedBox(width: 20),
                          _buildSocialButton('assets/icons/svg/apple.svg', () {
                            // Handle Apple login
                          }),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '아직 멤버가 아니신가요?',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Text(
                              '연결하러 가기',
                              style: TextStyle(
                                  color: AppColors().mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 60,
              color: AppColors().mainColor,
              child: const Text(
                '© 2024 MyCompany. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }
}
