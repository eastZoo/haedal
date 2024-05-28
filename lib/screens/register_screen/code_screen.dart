import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final authCon = Get.put(AuthController());

  bool inviteCode = false;

  bool isLoading = false;

  // text editing controllers
  final inviteCodeController = TextEditingController();
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    // 초대코드 텍스트 얻어오는 컨트롤러 부착
    inviteCodeController.addListener(() {
      // 초대코드 하나라도 입력하면 버튼 활성화
      if (inviteCodeController.text.isNotEmpty) {
        setState(() {
          inviteCode = true;
        });
      } else {
        setState(() {
          inviteCode = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    inviteCodeController.dispose();
    authCon.timer.cancel();
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
          // 로그아웃
          void logOut() {
            authCon.timer.cancel();
            authCon.update();

            const storage = FlutterSecureStorage();
            storage.delete(key: "accessToken");

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }

          // 연결하기
          onConnect() async {
            setState(() {
              isLoading = true;
            });
            var result = await authCon.onConnect(inviteCodeController.text);
            if (result["success"]) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/splash',
                (route) => false,
              );
            } else {
              setState(() {
                isLoading = false;
              });
              CustomToast().alert(result["msg"]);
            }
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors().white,
            body: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(150),
                      // logo
                      // Image.asset(
                      //   "assets/icons/Step2.png",
                      //   width: 100,
                      // ),

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
                        child: Row(
                          children: [
                            Expanded(
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
                            ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text:
                                          '${authCon.coupleConnectInfo?.code}'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Text copied to clipboard'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  side: const BorderSide(
                                    width: 1.0,
                                    color: Colors.transparent,
                                  )),
                              child: const Icon(Icons.content_copy,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                            Text(
                              "나의 초대코드",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors().darkGreyText),
                              textAlign: TextAlign.left,
                            ),
                            MyTextField(
                              controller: inviteCodeController,
                              hintText: '전달받은 초대코드 입력',
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 초대코드 입력 테스트 필드
                      MyTextField(
                        controller: inviteCodeController,
                        hintText: '전달받은 초대코드 입력',
                        obscureText: false,
                      ),

                      const SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        title: "연결하기",
                        onTap: onConnect,
                        available: inviteCode && !isLoading,
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
