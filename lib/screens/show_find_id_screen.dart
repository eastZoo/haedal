import 'package:flutter/material.dart';

class ShowFindIdScreen extends StatelessWidget {
  final String userEmail;

  const ShowFindIdScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 찾기 결과'),
      ),
      body: Center(
        child: Text('찾으신 아이디는: $userEmail'),
      ),
    );
  }
}
