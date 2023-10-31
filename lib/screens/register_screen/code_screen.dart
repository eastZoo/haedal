import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final authCon = Get.put(AuthController());

  // text editing controllers
  final emailController = TextEditingController();
  FocusNode userEmailfocusNode = FocusNode();

  final passwordController = TextEditingController();

  // 인풋 에러 확인용 스테이트
  bool isEmailValid = true;
  bool isPasswordValid = true;

  // 버튼 관련상태
  bool email = false;
  bool password = false;

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    authCon.timer.cancel();
  }

  // 회원가입
  void onConnect() {}

  logOut() {
    const storage = FlutterSecureStorage();
    storage.delete(key: "accessToken");

    authCon.timer.cancel();
    authCon.update();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String format(int second) {
      var duration = Duration(seconds: second).toString().split(".");

      return duration[0];
    }

    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
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
                        "assets/icons/register-2.png",
                      ),

                      const SizedBox(height: 15),

                      // welcome back, you've been missed!
                      Text(
                        '서로의 초대코드를 입력하여 연결해 주세요',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // username textfield
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text:
                                  '${authCon.coupleConnectInfo?.code ?? "Loading.."}'),
                          decoration: InputDecoration(
                            labelText:
                                '내 초대코드 (${format(authCon.accessCodeTimer)})',
                            labelStyle: TextStyle(
                              fontSize: 16, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                              letterSpacing: 2.0, // Letter spacing
                              wordSpacing: 4.0, // Word spacing
                              color: Colors.grey[850],
                            ),
                            // isValid가 false면 에러메세지 아이콘
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: '전달받은 초대코드 입력',
                        obscureText: true,
                      ),

                      const SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        title: "연결하기",
                        onTap: onConnect,
                        available: email && password,
                      ),

                      const SizedBox(height: 50),
                      MyButton(title: "로그아웃", onTap: logOut, available: true),
                      // or continue with
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
