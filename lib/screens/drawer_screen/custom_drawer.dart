import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/work_table_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void logOut() {
      const storage = FlutterSecureStorage();
      storage.delete(key: "accessToken");

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }

    return GetBuilder<AuthController>(builder: (AuthCon) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
            // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                // 현재 계정 이미지 set
                backgroundImage: AssetImage('assets/icons/profile.png'),
                backgroundColor: Colors.white,
              ),
              accountName: Text(AuthCon.userInfo?.name ?? ""),
              accountEmail: Text(AuthCon.userInfo?.userEmail ?? ""),
              decoration: BoxDecoration(
                color: AppColors().mainColor,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.backup_table_sharp,
                color: Colors.grey[850],
              ),
              title: const Text('근무표'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const WorkTableScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey[850],
              ),
              title: const Text('로그아웃'),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      );
    });
  }
}
