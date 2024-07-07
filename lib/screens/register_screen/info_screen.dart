import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
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

  final AuthController authCon = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    authCon.onInit();
    // coupleInfo가 변경될 때마다 nameController.text를 업데이트
    ever(authCon.coupleInfo, (coupleInfo) {
      if (coupleInfo?.me?.name != null) {
        nameController.text = coupleInfo?.me?.name ?? '';
      }
      if (coupleInfo?.me?.birth != null) {
        // WidgetsBinding.instance.addPostFrameCallback을 사용하여 렌더링이 완료된 후에 실행되도록 함
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            selectedDate = coupleInfo?.me?.birth ?? DateTime.now();
            birthController.text =
                "${coupleInfo?.me?.birth?.toLocal()}".split(' ')[0];
          });
        });
      }
    });
  }

// 시작하기 버튼 클릭 시
  void onStart() async {
    setState(() {
      isLoading = true;
    });
    if (selectedValue == null) {
      CustomToast().alert("성별을 선택해주세요");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (nameController.text.isEmpty || birthController.text.length < 0) {
      CustomToast().alert("이름을 입력해주세요");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (birthController.text.isEmpty || birthController.text.length < 0) {
      CustomToast().alert("이름을 입력해주세요");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (firstDayController.text.isEmpty || firstDayController.text.length < 0) {
      CustomToast().alert("처음 만난 날을 입력해주세요");
      setState(() {
        isLoading = false;
      });
      return;
    }
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
                  MyTextField(
                    controller: nameController,
                    hintText: '이름',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
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
                    onTap: () async {
                      onStart();
                    },
                    available: true,
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    title: "로그아웃",
                    onTap: () {
                      const storage = FlutterSecureStorage();
                      storage.delete(key: "accessToken");

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    available: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
