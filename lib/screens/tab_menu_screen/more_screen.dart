import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:haedal/widgets/main_appbar.dart';
import 'package:haedal/widgets/my_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  void logOut() {
    const storage = FlutterSecureStorage();
    storage.delete(key: "accessToken");

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MainAppbar(title: '더보기'),
          Expanded(
              child: Column(
            children: [
              MyButton(
                onTap: logOut,
                title: "로그아웃",
                available: true,
              )
            ],
          ))
        ],
      ),
    );
  }
}
