import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/label_textfield.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final authCon = Get.find<AuthController>();

  bool inviteCode = false;
  bool isLoading = false;

  final codeController = TextEditingController();
  final inviteCodeController = TextEditingController();
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    authCon.onInit();

    codeController.text = "${authCon.coupleConnectInfo?.code}" ?? "Loading..";

    inviteCodeController.addListener(() {
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
    inviteCodeController.dispose();
    authCon.timer.cancel();
    super.dispose();
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
                      const Gap(120),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/icons/step-2.png",
                          width: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/icons/Step2.png",
                          width: 95,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '서로의 초대코드를 입력하여 연결해 주세요',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        '나의 초대코드',
                        style: TextStyle(
                          color: AppColors().darkGreyText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${authCon.coupleConnectInfo?.code ?? "Loading.."}',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          color: AppColors().mainColor,
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${format(authCon.accessCodeTimer)} 남음",
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 45),
                      MyButton(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: '${authCon.coupleConnectInfo?.code}'));
                          CustomToast().alert("클립보드에 복사되었습니다.");
                        },
                        title: "초대코드 복사하기",
                        available: true,
                        backgroundColor: AppColors().lightGrey,
                        textColor: AppColors().darkGreyText,
                      ),
                      const Gap(10),
                      MyButton(
                        onTap: () {
                          CustomToast().alert("카카오톡 공유하기 준비중입니다...");
                        },
                        icon: Image.asset(
                          "assets/icons/kakao.png",
                          width: 18,
                        ),
                        title: "카카오톡 공유하기",
                        available: true,
                        backgroundColor: AppColors().kakaoYellow,
                        textColor: Colors.black,
                      ),
                      const Gap(20),
                      LabelTextField(
                        controller: inviteCodeController,
                        hintText: '전달받은 초대코드 입력',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
              child: MyButton(title: "다음", onTap: onConnect, available: true),
            ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
            //   child: MyButton(title: "로그아웃", onTap: logOut, available: true),
            // ),
          );
        });
  }
}
