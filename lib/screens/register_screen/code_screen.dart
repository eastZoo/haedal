import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      const Gap(100),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/icons/Step2.png",
                          width: 100,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '서로의 초대코드를 입력하여 연결해 주세요',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      LabelTextField(
                        label: "나의 초대코드",
                        controller: TextEditingController(
                            text:
                                '${authCon.coupleConnectInfo?.code ?? "Loading.."}'),
                        textStyle: TextStyle(color: AppColors().mainColor),
                        obscureText: false,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.content_copy,
                            color: AppColors().mainColor,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                  text: '${authCon.coupleConnectInfo?.code}'),
                            );
                            CustomToast().alert("복사되었습니다.", type: "success");
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${format(authCon.accessCodeTimer)} 남음",
                            style: const TextStyle(color: Colors.red),
                          ),
                          MyButton(title: "재전송", onTap: () {}, available: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LabelTextField(
                        controller: inviteCodeController,
                        hintText: '전달받은 초대코드 입력',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyButton(
                        title: "연결하기",
                        onTap: onConnect,
                        available: inviteCode && !isLoading,
                      ),
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
