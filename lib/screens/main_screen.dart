import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '미션 진행중',
                style: TextStyle(
                  color: Color(0xFF2E397C),
                  fontSize: 10,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.60,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '걷기미션을 진행하고 있습니다!',
                style: TextStyle(
                  color: Color(0xFF2B2F45),
                  fontSize: 13,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.78,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
