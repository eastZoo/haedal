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
  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final firstDayController = TextEditingController();

  String? selectedValue;

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

          // 개인정보 입력 후 시작하기
          void onStartConnect() async {
            Map<String, dynamic> dataSource = {
              "sex": selectedValue,
              "name": nameController.text,
              "birth": birthController.text,
              "firstDay": firstDayController.text
            };
            var result = await authCon.onStartConnect(dataSource);
            print("onStartConnect   : $result");
            if (result) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            }
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

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('남자'),
                              value: '1',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('여자'),
                              value: '0',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),

                      // password textfield
                      MyTextField(
                        controller: nameController,
                        hintText: '이름',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: birthController,
                        hintText: '생일 (만 14세 이상 사용가능)',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: firstDayController,
                        hintText: '처음 만난 날 (선택입력)',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),
                      MyButton(
                          title: "시작하기",
                          onTap: onStartConnect,
                          available: true),

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
