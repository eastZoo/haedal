import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/loading_overlay.dart';
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

  bool isLoading = false;

  String? selectedValue;
  DateTime selectedDate = DateTime.now();

  void _showDatePicker(BuildContext context, TextEditingController controller) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                        controller.text = "${newDate.toLocal()}".split(' ')[0];
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  color: AppColors().mainColor,
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

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

            if (result) {
              Timer(const Duration(milliseconds: 500), () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/splash',
                  (route) => false,
                );
                setState(() {
                  isLoading = false;
                });
              });
            }
          }

          return LoadingOverlay(
            isLoading: isLoading,
            child: Scaffold(
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
                        const Gap(100),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/Step3.png",
                            width: 100,
                          ),
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
                          readOnly: true,
                          onTap: () {
                            _showDatePicker(context, birthController);
                          },
                        ),
                        const SizedBox(height: 10),

                        // password textfield
                        MyTextField(
                          controller: firstDayController,
                          hintText: '처음 만난 날 (선택입력)',
                          readOnly: true,
                          obscureText: false,
                          onTap: () {
                            _showDatePicker(context, firstDayController);
                          },
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
            ),
          );
        });
  }
}
