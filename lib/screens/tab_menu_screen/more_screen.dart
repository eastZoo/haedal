import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:haedal/widgets/my_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              print("로그아웃");
              const storage = FlutterSecureStorage();
              await storage.delete(key: 'accessToken');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: MyButton(
              title: '로그아웃',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
