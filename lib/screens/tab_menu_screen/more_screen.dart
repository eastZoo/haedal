import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';

import 'package:haedal/widgets/my_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isExpanded = false;

  final authCon = Get.put(AuthController());

  // Function to show final confirmation dialog
  void _showFinalDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "계정탈퇴 최종확인",
            style: TextStyle(
              color: AppColors().darkGreyText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 50,
            child: Column(
              children: [
                Text(
                  '지금까지 해달을 이용해주셔서 감사합니다.',
                  style: TextStyle(
                    color: AppColors().mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(5),
                Text(
                  '[ 확인 ] 버튼을 누르면 탈퇴가 진행됩니다.',
                  style: TextStyle(
                    color: AppColors().darkGreyText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().mainColor,
                    shadowColor: Colors.transparent),
                onPressed: () async {
                  var result = await authCon.deleteUser();
                  if (result) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                },
                child: Text(
                  '확인',
                  style: TextStyle(color: AppColors().white),
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().darkGrey,
                  shadowColor: Colors.transparent),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(color: AppColors().white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to show confirmation dialog
  void _showDeleteAccountDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "계정탈퇴",
              style: TextStyle(
                color: AppColors().darkGreyText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '계정을 정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
              style: TextStyle(
                color: AppColors().mainColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().mainColor,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showFinalDeleteAccountDialog(); // Show final confirmation dialog
                  },
                  child: Text(
                    '예',
                    style: TextStyle(color: AppColors().white),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().darkGrey,
                    shadowColor: Colors.transparent),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '아니오',
                  style: TextStyle(color: AppColors().white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            MyButton(
              available: true,
              title: '로그아웃',
              onTap: () async {
                print("로그아웃");
                const storage = FlutterSecureStorage();
                await storage.delete(key: 'accessToken');
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            const Gap(20),
            GestureDetector(
              onTap: () async {
                print("계정탈퇴");
                _showDeleteAccountDialog();
              },
              child: MyButton(
                title: '계정탈퇴',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
