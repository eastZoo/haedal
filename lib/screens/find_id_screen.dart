import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/show_find_id_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final nameController = TextEditingController();
  final birthController = TextEditingController();

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
      // if (coupleInfo?.me?.birth != null) {
      //   // WidgetsBinding.instance.addPostFrameCallback을 사용하여 렌더링이 완료된 후에 실행되도록 함
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     setState(() {
      //       selectedDate = coupleInfo?.me?.birth ?? DateTime.now();
      //       birthController.text =
      //           "${coupleInfo?.me?.birth?.toLocal()}".split(' ')[0];
      //     });
      //   });
      // }
    });
  }

  // 아이디
  void onFindId() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (nameController.text.isEmpty || birthController.text.isEmpty) {
        CustomToast().alert("이름과 생일을 입력해주세요");
        setState(() {
          isLoading = false;
        });
        return;
      }

      Map<String, dynamic> dataSource = {
        "name": nameController.text,
        "birth": birthController.text,
      };
      print(dataSource);
      var result = await authCon.onFindId(dataSource);

      print("SDadsas $result");

      if (result["data"]["success"]) {
        final userEmail = result["data"]["userEmail"];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowFindIdScreen(userEmail: userEmail),
          ),
        );
      } else {
        CustomToast().alert("아이디를 찾을 수 없습니다.");
      }
    } catch (e) {
      CustomToast().alert("서버에러 : $e.");
    } finally {
      setState(() {
        isLoading = false;
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
                      "assets/icons/logo.png",
                      width: 140,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '해달 가입 정보로',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '아이디를 확인하세요',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  MyButton(
                    title: "아이디 찾기",
                    onTap: () async {
                      onFindId();
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
