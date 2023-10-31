import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
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

  // 비밀번호 텍스트 controllers
  bool isEmailValid = true;

  bool isPasswordValid = true;

  // 버튼 관련상태
  bool email = false;

  bool password = false;

  // 이메일 형식 판별 정규식
  RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  // 비밀번호 유효성 검사 정규식 ( 영문 숫자 포함 8자 이상 )
  RegExp passwordRegex = RegExp(r'^(?=.*[0-9])[a-zA-Z0-9]{8,}$');

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    // 이메일 텍스트 얻어오는 컨트롤러 부착
    emailController.addListener(() {
      // 공백제거

      if (emailRegex.hasMatch(emailController.text)) {
        setState(() {
          email = emailController.text.isNotEmpty;
          isEmailValid = true;
        });
      } else {
        setState(() {
          email = false;
        });
      }
    });
    // 비밀번호 얻어오는 컨트롤러 부착
    passwordController.addListener(() {
      // 영문 숫자 포함 8자 이상일 때만 true
      if (passwordRegex.hasMatch(passwordController.text)) {
        setState(() {
          password = passwordController.text.isNotEmpty;
        });
      } else {
        setState(() {
          password = false;
        });
      }
    });
    // 이메일 커서 포커스 감지하는 함수 부착
    userEmailfocusNode.addListener(() {
      if (!userEmailfocusNode.hasFocus) {
        cursorMovedOutOfEmailTextField();
      }
    });
  }

  // 이메일 텍스트필드에서 커서 Out 됬을때 실행되는 함수
  void cursorMovedOutOfEmailTextField() async {
    // 커서 아웃됬을때 공백 전부 삭제
    emailController.text = emailController.text.replaceAll(" ", "");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // logo
                      const Icon(
                        Icons.brightness_high_sharp,
                        size: 70,
                      ),

                      const SizedBox(height: 50),

                      // welcome back, you've been missed!
                      Text(
                        'Haeon & Dongju',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // username textfield
                      MyTextField(
                        controller: emailController,
                        hintText: '이메일',
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

                      // forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '비밀번호를 잊으셨나요?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        title: "로그인",
                        onTap: () async => {
                          await authCon.onSignIn(
                              emailController.text, passwordController.text),
                          Navigator.pushNamed(context, '/splash')
                        },
                        available: email && password,
                      ),

                      const SizedBox(height: 50),

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
                                '저희와 함께 하실래요?',
                                style: TextStyle(color: Colors.grey[700]),
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
                        children: [
                          Text(
                            '아직 멤버가 아니신가요?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            child: const Text(
                              '연결하러 가기',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
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
          );
        });
  }
}
